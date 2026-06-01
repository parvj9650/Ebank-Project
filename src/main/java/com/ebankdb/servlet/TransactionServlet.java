package com.ebankdb.servlet;

import com.ebankdb.dao.AccountDAO;
import com.ebankdb.dao.TransactionDAO;
import com.ebankdb.model.Transaction;
import com.ebankdb.model.User;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;

@WebServlet("/viewAllTransactions")
public class TransactionServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        TransactionDAO txnDAO = new TransactionDAO();
        AccountDAO accDAO = new AccountDAO();

        String accountParam = request.getParameter("accountId");
        String action = request.getParameter("action");

        HttpSession session = request.getSession(false);
        User user = (User) session.getAttribute("user");

        if(user == null){
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        List<Transaction> transactions;
        List<Integer> accounts;

        // MANAGER: Can see both Open and Closed accounts
        if(user.getRole().equals("Manager")) {
            String statusParam = request.getParameter("status");
            if(statusParam == null) {
                statusParam = "open"; // default to open accounts
            }

            // Handle "Show All Accounts" action
            if("showAll".equals(action)) {
                if ("closed".equals(statusParam)) {
                    transactions = txnDAO.getClosedAccountTransactions();
                    accounts = accDAO.getAccountIdsByStatus("Closed");
                } else {
                    transactions = txnDAO.getOpenAccountTransactions();
                    accounts = accDAO.getAccountIdsByNotClosed();
                }
            }
            // Handle text-based account search
            else if (accountParam != null && !accountParam.trim().isEmpty()) {
                try {
                    int accountId = Integer.parseInt(accountParam);

                    if ("closed".equals(statusParam)) {
                        transactions = txnDAO.getTransactionsByAccountAndStatus(accountId, "Closed");
                        accounts = accDAO.getAccountIdsByStatus("Closed");
                    } else {
                        transactions = txnDAO.getTransactionsByAccountAndNotClosed(accountId);
                        accounts = accDAO.getAccountIdsByNotClosed();
                    }
                } catch (NumberFormatException e) {
                    // Invalid account ID - show all based on status
                    if ("closed".equals(statusParam)) {
                        transactions = txnDAO.getClosedAccountTransactions();
                        accounts = accDAO.getAccountIdsByStatus("Closed");
                    } else {
                        transactions = txnDAO.getOpenAccountTransactions();
                        accounts = accDAO.getAccountIdsByNotClosed();
                    }
                    request.setAttribute("error", "invalidId");
                }
            }
            // Default - show all based on status
            else {
                if ("closed".equals(statusParam)) {
                    transactions = txnDAO.getClosedAccountTransactions();
                    accounts = accDAO.getAccountIdsByStatus("Closed");
                } else {
                    transactions = txnDAO.getOpenAccountTransactions();
                    accounts = accDAO.getAccountIdsByNotClosed();
                }
            }
        }
        // EMPLOYEE: Can ONLY see Open Accounts
        else {
            // Handle "Show All Accounts" action
            if("showAll".equals(action)) {
                transactions = txnDAO.getOpenAccountTransactions();
                accounts = accDAO.getAccountIdsByNotClosed();
            }
            // Handle text-based account search
            else if (accountParam != null && !accountParam.trim().isEmpty()) {
                try {
                    int accountId = Integer.parseInt(accountParam);
                    transactions = txnDAO.getTransactionsByAccountAndNotClosed(accountId);
                    accounts = accDAO.getAccountIdsByNotClosed();
                } catch (NumberFormatException e) {
                    transactions = txnDAO.getOpenAccountTransactions();
                    accounts = accDAO.getAccountIdsByNotClosed();
                    request.setAttribute("error", "invalidId");
                }
            }
            // Default - show all open accounts
            else {
                transactions = txnDAO.getOpenAccountTransactions();
                accounts = accDAO.getAccountIdsByNotClosed();
            }
        }

        request.setAttribute("transactions", transactions);
        request.setAttribute("accounts", accounts);
        request.setAttribute("userRole", user.getRole());

        // Route to the correct JSP based on role
        RequestDispatcher rd;
        if (user.getRole().equals("Manager")) {
            rd = request.getRequestDispatcher("/manager/transactions.jsp");
        } else {
            rd = request.getRequestDispatcher("/employee/transactions.jsp");
        }

        rd.forward(request, response);
    }
}
package com.ebankdb.servlet;

import com.ebankdb.dao.TransactionDAO;
import com.ebankdb.model.Transaction;
import com.ebankdb.model.User;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet("/transactionSummary")
public class TransactionSummaryServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        TransactionDAO dao = new TransactionDAO();
        String accountParam = request.getParameter("accountId");
        String action = request.getParameter("action");

        List<Transaction> list;

        // Handle "Show All Accounts" action
        if("showAll".equals(action)) {
            list = dao.getTransactionSummary();
        }
        // Handle text-based account search
        else if (accountParam != null && !accountParam.trim().isEmpty()) {
            try {
                int accountId = Integer.parseInt(accountParam);
                list = dao.getTransactionSummaryByAccount(accountId);
                if(list == null || list.isEmpty()) {
                    request.setAttribute("error", "noTransactions");
                }
            } catch (NumberFormatException e) {
                list = dao.getTransactionSummary();
                request.setAttribute("error", "invalidId");
            }
        }
        // Default - show all
        else {
            list = dao.getTransactionSummary();
        }

        request.setAttribute("transactions", list);

        HttpSession session = request.getSession(false);
        User user = (User) session.getAttribute("user");
        RequestDispatcher rd;

        if (user.getRole().equals("Manager")) {
            rd = request.getRequestDispatcher("manager/transactionSummary.jsp");
        } else {
            rd = request.getRequestDispatcher("employee/transactionSummary.jsp");
        }

        rd.forward(request, response);
    }
}
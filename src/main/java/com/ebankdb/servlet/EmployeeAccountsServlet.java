package com.ebankdb.servlet;

import com.ebankdb.dao.AccountDAO;
import com.ebankdb.model.Account;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet("/manageAccounts")
public class EmployeeAccountsServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        AccountDAO dao = new AccountDAO();
        String accountParam = request.getParameter("accountId");
        String action = request.getParameter("action");

        List<Account> accounts;

        // Handle "Show All" action
        if("showAll".equals(action)) {
            accounts = dao.getAllAccounts();
        }
        // Handle search by account ID
        else if (accountParam != null && !accountParam.trim().isEmpty()) {
            try {
                int accountId = Integer.parseInt(accountParam);
                accounts = dao.getAccountsByFilter(accountId);
            } catch (NumberFormatException e) {
                accounts = dao.getAllAccounts();
                request.setAttribute("error", "invalidId");
            }
        } else {
            accounts = dao.getAllAccounts();
        }

        List<Integer> accountIds = dao.getAllAccountIds();
        request.setAttribute("accounts", accounts);
        request.setAttribute("accountIds", accountIds);
        request.getRequestDispatcher("employee/manageAccounts.jsp").forward(request, response);
    }
}
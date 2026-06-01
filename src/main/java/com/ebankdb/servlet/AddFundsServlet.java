package com.ebankdb.servlet;

import com.ebankdb.dao.AccountDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet.*;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.math.BigDecimal;

@WebServlet("/addFunds")
public class AddFundsServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)throws ServletException, IOException {
        int accountId = Integer.parseInt(request.getParameter("accountId"));

        request.setAttribute("accountId", accountId);
        request.getRequestDispatcher("customer/addFunds.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int accountId = Integer.parseInt(request.getParameter("accountId"));
        String amountStr = request.getParameter("amount");
        BigDecimal amount;

        try {
            amount = new BigDecimal(amountStr);
            if (amount.compareTo(BigDecimal.ZERO) <= 0) {
                throw new Exception();
            }

        } catch (Exception e) {
            request.setAttribute("error", "Invalid amount");
            request.setAttribute("accountId", accountId);
            request.getRequestDispatcher("customer/addFunds.jsp").forward(request, response);
            return;
        }

        AccountDAO dao = new AccountDAO();
        boolean success = dao.addFunds(accountId, amount);

        if (success) {
            response.sendRedirect("viewAccounts?success=deposit");
        } else {
            request.setAttribute("error", "Account is Frozen or Closed");
            request.setAttribute("accountId", accountId);
            request.getRequestDispatcher("customer/addFunds.jsp").forward(request, response);
        }
    }
}

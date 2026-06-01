package com.ebankdb.servlet;

import com.ebankdb.dao.TransactionDAO;
import com.ebankdb.model.Transaction;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;

@WebServlet("/viewTransactions")
public class CustomerTransactionServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int accountId = Integer.parseInt(request.getParameter("accountId"));
        TransactionDAO dao = new TransactionDAO();
        List<Transaction> transactions = dao.getTransactionsByAccountId(accountId);

        request.setAttribute("transactions", transactions);
        RequestDispatcher rd = request.getRequestDispatcher("customer/transactions.jsp");

        rd.forward(request, response);
    }
}
package com.ebankdb.servlet;

import com.ebankdb.dao.AccountDAO;
import com.ebankdb.dao.CustomerDAO;
import com.ebankdb.model.Account;
import com.ebankdb.model.User;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;

@WebServlet("/viewAccounts")
public class AccountServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();

        User user = (User) session.getAttribute("user");
        int userId = user.getUserId();

        CustomerDAO customerDAO = new CustomerDAO();
        int customerId = customerDAO.getCustomerIdByUserId(userId);

        AccountDAO dao = new AccountDAO();
        List<Account> accounts = dao.getAccountsByCustomerId(customerId);

        request.setAttribute("accounts", accounts);
        RequestDispatcher rd = request.getRequestDispatcher("customer/accounts.jsp");

        rd.forward(request, response);
    }
}
package com.ebankdb.servlet;

import com.ebankdb.dao.CustomerDAO;
import com.ebankdb.dao.FixedDepositDAO;
import com.ebankdb.model.FixedDeposit;
import com.ebankdb.model.User;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;

@WebServlet("/viewFDs")
public class FixedDepositServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();

        User user = (User) session.getAttribute("user");
        int userId = user.getUserId();

        CustomerDAO customerDAO = new CustomerDAO();
        int customerId = customerDAO.getCustomerIdByUserId(userId);

        FixedDepositDAO dao = new FixedDepositDAO();
        List<FixedDeposit> fds = dao.getFDsByCustomer(customerId);

        request.setAttribute("fds", fds);

        RequestDispatcher rd = request.getRequestDispatcher("customer/fixedDeposits.jsp");
        rd.forward(request, response);
    }

}
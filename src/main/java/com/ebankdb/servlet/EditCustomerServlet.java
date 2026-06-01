package com.ebankdb.servlet;

import com.ebankdb.dao.CustomerDAO;
import com.ebankdb.model.Customer;
import com.ebankdb.model.User;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/editCustomerProfile")
public class EditCustomerServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if(user == null){
            response.sendRedirect("login.jsp");
            return;
        }

        CustomerDAO dao = new CustomerDAO();
        Customer customer = dao.getCustomerByUserId(user.getUserId());

        request.setAttribute("customer", customer);
        request.getRequestDispatcher("customer/editProfile.jsp").forward(request, response);
    }
}
package com.ebankdb.servlet;

import com.ebankdb.dao.UserDAO;

import com.ebankdb.model.User;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
@WebServlet("/signup")
public class SignupServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String username = request.getParameter("username").trim();
        String password = request.getParameter("password").trim();
        String role = request.getParameter("role").trim();

        if (role.isEmpty()) {
            response.sendRedirect("signup.jsp?error=role");
            return;
        }

        UserDAO userDAO = new UserDAO();
        boolean success = userDAO.register(username, password, role);

        if (!success) {
            response.sendRedirect("signup.jsp?error=1");
            return;
        }

        User user = userDAO.login(username, password);

        HttpSession session = request.getSession();
        session.setAttribute("user", user);

        if (role.equals("Customer")) {
            response.sendRedirect("customer/profile.jsp");
        }
        else if (role.equals("Employee")) {
            response.sendRedirect("employeeProfile");
        }
        else if (role.equals("Manager")) {
            response.sendRedirect("managerRegisterPage");
        }
    }
}
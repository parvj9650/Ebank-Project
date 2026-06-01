package com.ebankdb.servlet;

import com.ebankdb.dao.CustomerDAO;
import com.ebankdb.dao.EmployeeDAO;
import com.ebankdb.dao.ManagerDAO;
import com.ebankdb.dao.UserDAO;
import com.ebankdb.model.Customer;
import com.ebankdb.model.Employee;
import com.ebankdb.model.Manager;
import com.ebankdb.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        UserDAO dao = new UserDAO();
        User user = dao.login(username, password);

        if (user != null) {
            HttpSession session = request.getSession();
            session.setAttribute("user", user);
            String role = user.getRole();

            if (role.equals("Customer")) {
                CustomerDAO customerDAO = new CustomerDAO();
                Customer customer = customerDAO.getCustomerByUserId(user.getUserId());

                if(customer == null){
                    response.sendRedirect("customer/profile.jsp");
                    return;
                } else {
                    session.setAttribute("customer", customer);
                    response.sendRedirect("customer/dashboard.jsp");
                }
            }
            else if (role.equals("Employee")) {
                EmployeeDAO employeeDAO = new EmployeeDAO();
                Employee employee = employeeDAO.getEmployeeByUserId(user.getUserId());

                if(employee == null){
                    response.sendRedirect("employeeProfile");
                    return;
                }
                else{
                    session.setAttribute("employee", employee);
                    response.sendRedirect("employee/dashboard.jsp");
                }
            }
            else if (role.equals("Manager")) {
                ManagerDAO managerDAO = new ManagerDAO();
                boolean profileComplete = managerDAO.isManagerProfileComplete(user.getUserId());

                if(!profileComplete){
                    response.sendRedirect("managerRegisterPage");
                    return;
                } else {
                    Manager manager = managerDAO.getManagerByUserId(user.getUserId());
                    session.setAttribute("manager", manager);

                    response.sendRedirect("manager/dashboard.jsp");
                    return;
                }
            }
        } else {
            response.sendRedirect("login.jsp?error=1");
        }
    }

}
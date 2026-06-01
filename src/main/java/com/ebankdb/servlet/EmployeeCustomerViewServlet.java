package com.ebankdb.servlet;

import com.ebankdb.dao.EmployeeDAO;
import com.ebankdb.model.User;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;
import java.util.Map;

@WebServlet("/employeeCustomerView")
public class EmployeeCustomerViewServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Check if user is logged in and is an employee
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if(user == null){
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        if(!"Employee".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/dashboard.jsp");
            return;
        }

        EmployeeDAO dao = new EmployeeDAO();
        String customerIdParam = request.getParameter("customerId");
        String action = request.getParameter("action");

        List<Map<String, Object>> data;

        // Handle "Show All" action
        if("showAll".equals(action)) {
            data = dao.getCustomerDetailsForEmployee();
        }
        // Handle search by customer ID
        else if (customerIdParam != null && !customerIdParam.trim().isEmpty()) {
            try {
                int customerId = Integer.parseInt(customerIdParam);
                data = dao.getCustomerDetailsByIdForEmployee(customerId);
                if(data == null || data.isEmpty()) {
                    request.setAttribute("error", "noData");
                }
            } catch (NumberFormatException e) {
                data = dao.getCustomerDetailsForEmployee();
                request.setAttribute("error", "invalidId");
            }
        }
        // Default - show all
        else {
            data = dao.getCustomerDetailsForEmployee();
        }

        request.setAttribute("data", data);
        RequestDispatcher rd = request.getRequestDispatcher("employee/customerView.jsp");
        rd.forward(request, response);
    }
}
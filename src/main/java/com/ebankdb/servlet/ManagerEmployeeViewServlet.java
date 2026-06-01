package com.ebankdb.servlet;

import com.ebankdb.dao.ManagerDAO;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;
import java.util.Map;

@WebServlet("/managerEmployeeView")
public class ManagerEmployeeViewServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        ManagerDAO dao = new ManagerDAO();
        String employeeIdParam = request.getParameter("employeeId");
        String action = request.getParameter("action");

        List<Map<String,Object>> data;

        // Handle "Show All" action
        if("showAll".equals(action)) {
            data = dao.getEmployeeDetails();
        }
        // Handle search by employee ID
        else if (employeeIdParam != null && !employeeIdParam.trim().isEmpty()) {
            try {
                int employeeId = Integer.parseInt(employeeIdParam);
                data = dao.getEmployeeDetailsById(employeeId);
                if(data == null || data.isEmpty()) {
                    request.setAttribute("error", "noData");
                }
            } catch (NumberFormatException e) {
                data = dao.getEmployeeDetails();
                request.setAttribute("error", "invalidId");
            }
        }
        else {
            data = dao.getEmployeeDetails();
        }

        request.setAttribute("data", data);
        RequestDispatcher rd = request.getRequestDispatcher("manager/employeeView.jsp");
        rd.forward(request, response);
    }
}
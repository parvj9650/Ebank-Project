package com.ebankdb.servlet;

import com.ebankdb.dao.ManagerDAO;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;
import java.util.Map;

@WebServlet("/managerCustomerView")
public class ManagerCustomerViewServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        ManagerDAO dao = new ManagerDAO();
        String customerIdParam = request.getParameter("customerId");
        String action = request.getParameter("action");

        List<Map<String,Object>> data;

        // Handle "Show All" action
        if("showAll".equals(action)) {
            data = dao.getCustomerDetails();
        }
        // Handle search by customer ID
        else if (customerIdParam != null && !customerIdParam.trim().isEmpty()) {
            try {
                int customerId = Integer.parseInt(customerIdParam);
                data = dao.getCustomerDetailsById(customerId);
                if(data == null || data.isEmpty()) {
                    request.setAttribute("error", "noData");
                }
            } catch (NumberFormatException e) {
                data = dao.getCustomerDetails();
                request.setAttribute("error", "invalidId");
            }
        }
        else {
            data = dao.getCustomerDetails();
        }

        request.setAttribute("data", data);
        RequestDispatcher rd = request.getRequestDispatcher("manager/customerView.jsp");
        rd.forward(request, response);
    }
}
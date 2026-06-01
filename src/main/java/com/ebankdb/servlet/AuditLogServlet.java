package com.ebankdb.servlet;

import com.ebankdb.dao.ManagerDAO;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;
import java.util.Map;

@WebServlet("/viewAuditLogs")
public class AuditLogServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        ManagerDAO dao = new ManagerDAO();
        String employeeIdParam = request.getParameter("employeeId");
        String action = request.getParameter("action");

        List<Map<String, Object>> logs;

        // Handle "Show All" action
        if("showAll".equals(action)) {
            logs = dao.getAuditLogs();
        }
        // Handle search by employee ID
        else if (employeeIdParam != null && !employeeIdParam.trim().isEmpty()) {
            try {
                int employeeId = Integer.parseInt(employeeIdParam);
                logs = dao.getAuditLogsByEmployeeId(employeeId);
                if(logs == null || logs.isEmpty()) {
                    request.setAttribute("error", "noData");
                }
            } catch (NumberFormatException e) {
                logs = dao.getAuditLogs();
                request.setAttribute("error", "invalidId");
            }
        }
        // Default - show all
        else {
            logs = dao.getAuditLogs();
        }

        request.setAttribute("logs", logs);
        RequestDispatcher rd = request.getRequestDispatcher("manager/auditLogs.jsp");
        rd.forward(request, response);
    }
}
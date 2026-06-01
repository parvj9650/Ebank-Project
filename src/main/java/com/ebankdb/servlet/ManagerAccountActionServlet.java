package com.ebankdb.servlet;

import com.ebankdb.config.DBConnection;
import com.ebankdb.dao.AccountDAO;
import com.ebankdb.dao.EmployeeDAO;
import com.ebankdb.model.User;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

@WebServlet("/managerAccountAction")
public class ManagerAccountActionServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String accountIdParam = request.getParameter("accountId");
        String action = request.getParameter("action");
        String currentSearchId = request.getParameter("currentSearchId"); // NEW: preserve search context

        // Check if accountId is provided for the action
        if(accountIdParam == null || accountIdParam.trim().isEmpty()) {
            response.sendRedirect("managerAccounts");
            return;
        }

        try {
            int accountId = Integer.parseInt(accountIdParam);

            HttpSession session = request.getSession();
            User user = (User) session.getAttribute("user");

            if(user == null){
                response.sendRedirect("login.jsp");
                return;
            }

            Connection conn = DBConnection.getConnection();

            EmployeeDAO employeeDAO = new EmployeeDAO();
            int empId = employeeDAO.getEmployeeIdByUserId(user.getUserId());

            PreparedStatement ps = conn.prepareStatement("SET @logged_in_employee_id = ?");
            ps.setInt(1, empId);
            ps.execute();

            AccountDAO dao = new AccountDAO();

            if ("freeze".equalsIgnoreCase(action)) {
                dao.freezeAccount(conn, accountId);
            } else if ("activate".equalsIgnoreCase(action)) {
                dao.activateAccount(conn, accountId);
            } else if ("close".equalsIgnoreCase(action)) {
                dao.closeAccount(conn, accountId);
            }

            conn.close();

        } catch (NumberFormatException e) {
            // Invalid account ID format
            response.sendRedirect("managerAccounts?error=invalidId");
            return;
        } catch (Exception e) {
            e.printStackTrace();
        }

        // FIXED: Redirect based on whether there was an active search
        if (currentSearchId != null && !currentSearchId.trim().isEmpty()) {
            // Preserve the search context
            response.sendRedirect("managerAccounts?accountId=" + currentSearchId);
        } else {
            // Show all accounts after action
            response.sendRedirect("managerAccounts");
        }
    }
}
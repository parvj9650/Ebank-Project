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

@WebServlet("/employeeAccountAction")
public class EmployeeAccountActionServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String action = request.getParameter("action");
        String accountIdParam = request.getParameter("accountId");
        String currentSearchId = request.getParameter("currentSearchId"); // NEW: preserve search context

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if(user == null){
            response.sendRedirect("login.jsp");
            return;
        }

        // Handle "Show All Accounts" action
        if("showAll".equals(action)) {
            response.sendRedirect("manageAccounts");
            return;
        }

        // Handle Search by Account ID
        if(accountIdParam != null && !accountIdParam.trim().isEmpty()) {
            try {
                int accountId = Integer.parseInt(accountIdParam);

                // If there's a freeze or activate action, process it
                if ("freeze".equalsIgnoreCase(action) || "activate".equalsIgnoreCase(action)) {
                    try {
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
                        }

                        conn.close();
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                }

                // FIXED: Redirect back to manageAccounts WITHOUT accountId parameter
                // unless there was an active search (currentSearchId)
                if (currentSearchId != null && !currentSearchId.trim().isEmpty()) {
                    // Preserve the search context
                    response.sendRedirect("manageAccounts?accountId=" + currentSearchId);
                } else {
                    // Show all accounts after action
                    response.sendRedirect("manageAccounts");
                }

            } catch(NumberFormatException e) {
                // Invalid account ID format
                response.sendRedirect("manageAccounts?error=invalidId");
            }
        } else {
            // No accountId provided - show all accounts
            response.sendRedirect("manageAccounts");
        }
    }
}
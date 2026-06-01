package com.ebankdb.servlet;

import com.ebankdb.config.DBConnection;
import com.ebankdb.dao.EmployeeDAO;
import com.ebankdb.model.User;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.*;
import java.util.*;

@WebServlet("/editEmployeeProfile")
public class EditEmployeeServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        EmployeeDAO dao = new EmployeeDAO();

        Map<String, Object> profile =
                dao.getEmployeeWithManagerDetails(user.getUserId());

        request.setAttribute("profile", profile);

        // ✅ Branch list
        List<Map<String, Object>> branches = new ArrayList<>();

        try {
            Connection conn = DBConnection.getConnection();
            String sql = "SELECT branch_id, branch_name FROM Branch";
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Map<String, Object> b = new HashMap<>();
                b.put("branch_id", rs.getInt("branch_id"));
                b.put("branch_name", rs.getString("branch_name"));
                branches.add(b);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        request.setAttribute("branches", branches);

        request.getRequestDispatcher("employee/editProfile.jsp").forward(request, response);
    }
}
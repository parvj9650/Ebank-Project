package com.ebankdb.servlet;

import com.ebankdb.config.DBConnection;
import com.ebankdb.dao.EmployeeDAO;
import com.ebankdb.model.User;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/updateManagerProfile")
public class UpdateManagerProfileServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        int branchId = Integer.parseInt(request.getParameter("branchId"));

        // VALIDATIONS
        if (name == null || !name.matches("[a-zA-Z ]+")) {
            error(request, response, "Invalid name");
            return;
        }

        if (phone == null || !phone.matches("\\d{10}")) {
            error(request, response, "Invalid phone");
            return;
        }

        if (email == null || !email.matches("^[A-Za-z0-9+_.-]+@(.+)$")) {
            error(request, response, "Invalid email");
            return;
        }

        EmployeeDAO dao = new EmployeeDAO();

        // ✅ Update
        dao.updateEmployeeProfile(user.getUserId(), name, email, phone, branchId);

        // ✅ Reload updated profile
        Map<String, Object> profile =
                dao.getEmployeeWithManagerDetails(user.getUserId());

        request.setAttribute("profile", profile);
        request.setAttribute("success", "Profile updated successfully");

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
        request.getRequestDispatcher("manager/editProfile.jsp").forward(request, response);
    }

    private void error(HttpServletRequest request, HttpServletResponse response, String msg)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        EmployeeDAO dao = new EmployeeDAO();
        Map<String, Object> profile =
                dao.getEmployeeWithManagerDetails(user.getUserId());

        request.setAttribute("profile", profile);
        request.setAttribute("error", msg);

        request.getRequestDispatcher("manager/editProfile.jsp").forward(request, response);
    }
}
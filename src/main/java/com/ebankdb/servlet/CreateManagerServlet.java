package com.ebankdb.servlet;

import com.ebankdb.config.DBConnection;
import com.ebankdb.dao.BranchDAO;
import com.ebankdb.dao.EmployeeDAO;
import com.ebankdb.dao.ManagerDAO;
import com.ebankdb.model.Employee;
import com.ebankdb.model.Manager;
import com.ebankdb.model.User;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.Connection;
import java.sql.Date;
import java.time.LocalDate;

@WebServlet("/createManager")
public class CreateManagerServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if(user == null){
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        int userId = user.getUserId();
        String name = request.getParameter("name");
        String designation = request.getParameter("designation");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        int branchId = Integer.parseInt(request.getParameter("branchId"));
        String hireDateStr = request.getParameter("hireDate");

        if(name == null || !name.matches("[a-zA-Z ]+")){
            error(request, response, "Name must contain only alphabets");
            return;
        }

        if(phone == null || !phone.matches("\\d{10}")){
            error(request, response, "Phone must be exactly 10 digits");
            return;
        }

        if(email == null || !email.matches("^[A-Za-z0-9+_.-]+@(.+)$")){
            error(request, response, "Invalid email format");
            return;
        }

        Date hireDate;
        try{
            hireDate = Date.valueOf(hireDateStr);

            LocalDate today = LocalDate.now();
            LocalDate hireLocal = hireDate.toLocalDate();

            if(hireLocal.isAfter(today)){
                error(request, response, "Hire date cannot be in the future");
                return;
            }

        } catch(Exception e){
            error(request, response, "Invalid hire date");
            return;
        }

        ManagerDAO mgrDAO = new ManagerDAO();
        Manager existingManager = mgrDAO.getManagerByUserId(userId);

        if(existingManager != null){
            // Manager already exists, just redirect
            session.setAttribute("manager", existingManager);
            response.sendRedirect(request.getContextPath() + "/manager/dashboard.jsp");
            return;
        }

        Connection conn = null;

        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            EmployeeDAO empDAO = new EmployeeDAO();

            // Check if employee already exists for this user
            Employee existingEmployee = empDAO.getEmployeeByUserId(userId);
            int employeeId;

            if(existingEmployee != null){
                employeeId = existingEmployee.getEmployeeId();
            } else {
                employeeId = empDAO.createEmployee(conn, userId, branchId, name, designation, hireDate);
            }

            // Create manager
            mgrDAO.createManager(conn, employeeId, name, email, phone);

            conn.commit();

            // Fetch and store manager in session
            Manager manager = mgrDAO.getManagerByUserId(userId);
            session.setAttribute("manager", manager);

            // Also store employee in session
            Employee employee = empDAO.getEmployeeByUserId(userId);
            session.setAttribute("employee", employee);

            response.sendRedirect(request.getContextPath() + "/manager/dashboard.jsp");
        } catch (Exception e) {
            try {
                if(conn != null) conn.rollback();
            } catch(Exception ex){
                ex.printStackTrace();
            }
            error(request, response, "Error creating manager");
        }
    }

    private void error(HttpServletRequest request, HttpServletResponse response, String msg) throws ServletException, IOException {
        request.setAttribute("error", msg);
        BranchDAO dao = new BranchDAO();
        request.setAttribute("branches", dao.getAllBranches());
        request.getRequestDispatcher("manager/register.jsp").forward(request, response);
    }
}
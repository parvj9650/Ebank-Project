package com.ebankdb.servlet;

import com.ebankdb.dao.BranchDAO;
import com.ebankdb.dao.EmployeeDAO;
import com.ebankdb.model.Employee;
import com.ebankdb.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.Date;
import java.time.LocalDate;
import java.time.Period;

@WebServlet("/saveEmployeeProfile")
public class SaveEmployeeProfileServlet extends HttpServlet {
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
        int branchId = Integer.parseInt(request.getParameter("branchId"));
        String hireDateStr = request.getParameter("hireDate");

        // NAME VALIDATION
        if(name == null || !name.matches("[a-zA-Z ]+")){
            request.setAttribute("error", "Name must contain only alphabets");
            BranchDAO branchDAO = new BranchDAO();
            request.setAttribute("branches", branchDAO.getAllBranches());
            request.getRequestDispatcher("employee/profile.jsp").forward(request, response);
            return;
        }

        Date hireDate;
        try{
            hireDate = Date.valueOf(hireDateStr);
        } catch(Exception e){
            request.setAttribute("error", "Invalid hire date");
            BranchDAO branchDAO = new BranchDAO();
            request.setAttribute("branches", branchDAO.getAllBranches());
            request.getRequestDispatcher("employee/profile.jsp").forward(request, response);
            return;
        }

        LocalDate today = LocalDate.now();
        LocalDate hireLocalDate = hireDate.toLocalDate();

        if(hireLocalDate.isAfter(today)){
            request.setAttribute("error", "Hire date cannot be in the future");
            BranchDAO branchDAO = new BranchDAO();
            request.setAttribute("branches", branchDAO.getAllBranches());
            request.getRequestDispatcher("employee/profile.jsp").forward(request, response);
            return;
        }

        EmployeeDAO dao = new EmployeeDAO();

        Employee existingEmployee = dao.getEmployeeByUserId(userId);

        if(existingEmployee != null){
            session.setAttribute("employee", existingEmployee);
            response.sendRedirect(request.getContextPath() + "/employee/dashboard.jsp");
            return;
        }

        dao.createEmployee(userId, branchId, name, designation, hireDate);

        Employee employee = dao.getEmployeeByUserId(userId);

        if(employee != null){
            session.setAttribute("employee", employee);
            response.sendRedirect(request.getContextPath() + "/employee/dashboard.jsp");
        } else {
            request.setAttribute("error", "Error creating employee profile. Please try again.");
            BranchDAO branchDAO = new BranchDAO();
            request.setAttribute("branches", branchDAO.getAllBranches());
            request.getRequestDispatcher("employee/profile.jsp").forward(request, response);
        }
    }
}
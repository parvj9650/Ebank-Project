package com.ebankdb.servlet;

import com.ebankdb.dao.BranchDAO;
import com.ebankdb.model.Branch;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;

@WebServlet("/employeeProfile")
public class EmployeeProfileServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        BranchDAO dao = new BranchDAO();
        List<Branch> branches = dao.getAllBranches();

        request.setAttribute("branches", branches);
        RequestDispatcher rd = request.getRequestDispatcher("employee/profile.jsp");

        rd.forward(request,response);
    }
}

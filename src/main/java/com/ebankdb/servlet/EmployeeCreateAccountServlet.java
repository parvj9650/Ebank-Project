package com.ebankdb.servlet;

import com.ebankdb.dao.AccountDAO;
import com.ebankdb.dao.BranchDAO;
import com.ebankdb.model.Branch;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;

@WebServlet("/employeeCreateAccount")
public class EmployeeCreateAccountServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int customerId = Integer.parseInt(request.getParameter("customerId"));

        BranchDAO branchDAO = new BranchDAO();
        List<Branch> branches = branchDAO.getAllBranches();

        request.setAttribute("branches", branches);
        request.setAttribute("customerId", customerId);

        RequestDispatcher rd = request.getRequestDispatcher("employee/createAccountForm.jsp");

        rd.forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        int customerId = Integer.parseInt(request.getParameter("customerId"));
        int branchId = Integer.parseInt(request.getParameter("branchId"));

        String balanceStr = request.getParameter("balance");
        String accountType = request.getParameter("accountType");

        BigDecimal balance;

        try {
            balance = new BigDecimal(balanceStr);
            if (balance.compareTo(BigDecimal.ZERO) < 0) {
                request.setAttribute("error", "Balance cannot be negative");
                request.setAttribute("customerId", customerId);
                request.setAttribute("balance", balanceStr);
                request.setAttribute("accountType", accountType);

                BranchDAO branchDAO = new BranchDAO();
                request.setAttribute("branches", branchDAO.getAllBranches());

                request.getRequestDispatcher("employee/createAccountForm.jsp").forward(request, response);
                return;
            }

        } catch (Exception e) {
            request.setAttribute("error", "Invalid balance amount");
            request.setAttribute("customerId", customerId);

            BranchDAO branchDAO = new BranchDAO();
            request.setAttribute("branches", branchDAO.getAllBranches());

            request.getRequestDispatcher("employee/createAccountForm.jsp").forward(request, response);
            return;
        }

        AccountDAO dao = new AccountDAO();
        dao.createAccount(customerId, branchId, balance, accountType);

        response.sendRedirect("manageAccounts");
    }
}
package com.ebankdb.servlet;

import com.ebankdb.dao.AccountDAO;
import com.ebankdb.dao.BranchDAO;
import com.ebankdb.dao.CustomerDAO;
import com.ebankdb.model.Branch;
import com.ebankdb.model.User;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;

@WebServlet("/createAccount")
public class CreateAccountServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        BranchDAO branchDAO = new BranchDAO();
        List<Branch> branches = branchDAO.getAllBranches();
        request.setAttribute("branches", branches);
        RequestDispatcher rd = request.getRequestDispatcher("customer/createAccount.jsp");
        rd.forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();

        User user = (User) session.getAttribute("user");
        int userId = user.getUserId();

        CustomerDAO customerDAO = new CustomerDAO();
        int customerId = customerDAO.getCustomerIdByUserId(userId);

        int branchId = Integer.parseInt(request.getParameter("branchId"));
        String balanceStr = request.getParameter("balance");
        String accountType = request.getParameter("accountType");

        BigDecimal balance;

        try {
            balance = new BigDecimal(balanceStr);

            if (balance.compareTo(BigDecimal.ZERO) < 0) {
                request.setAttribute("error", "Balance cannot be negative");
                BranchDAO branchDAO = new BranchDAO();
                List<Branch> branches = branchDAO.getAllBranches();
                request.setAttribute("branches", branches);
                request.setAttribute("selectedBranch", branchId);
                request.setAttribute("balance", balanceStr);
                request.setAttribute("accountType", accountType);

                request.getRequestDispatcher("customer/createAccount.jsp").forward(request, response);
                return;
            }

        } catch (Exception e) {
            request.setAttribute("error", "Invalid balance amount");

            BranchDAO branchDAO = new BranchDAO();
            List<Branch> branches = branchDAO.getAllBranches();
            request.setAttribute("branches", branches);

            request.getRequestDispatcher("customer/createAccount.jsp").forward(request, response);
            return;
        }

        AccountDAO dao = new AccountDAO();
        dao.createAccount(customerId, branchId, balance, accountType);

        response.sendRedirect("viewAccounts");
    }
}
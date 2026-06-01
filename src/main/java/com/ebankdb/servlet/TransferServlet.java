package com.ebankdb.servlet;

import com.ebankdb.dao.*;
import com.ebankdb.model.*;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;

@WebServlet("/transfer")
public class TransferServlet extends HttpServlet {
    private void loadData(HttpServletRequest request, User user) {
        CustomerDAO customerDAO = new CustomerDAO();
        int customerId = customerDAO.getCustomerIdByUserId(user.getUserId());

        AccountDAO accountDAO = new AccountDAO();
        List<Account> accounts = accountDAO.getAccountsByCustomerId(customerId);

        BeneficiaryDAO beneficiaryDAO = new BeneficiaryDAO();
        List<Beneficiary> beneficiaries = beneficiaryDAO.getBeneficiariesByCustomer(customerId);

        request.setAttribute("accounts", accounts);
        request.setAttribute("beneficiaries", beneficiaries);
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        loadData(request, user);

        RequestDispatcher rd = request.getRequestDispatcher("customer/transfer.jsp");
        rd.forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String fromAccStr = request.getParameter("fromAccount");
        String toAccStr = request.getParameter("toAccount");
        String amountStr = request.getParameter("amount");

        int fromAccount = 0;
        int toAccount = 0;
        BigDecimal amount = null;

        try {
            fromAccount = Integer.parseInt(fromAccStr);
            toAccount = Integer.parseInt(toAccStr);
            amount = new BigDecimal(amountStr);

            if(amount.compareTo(BigDecimal.ZERO) <= 0){
                throw new Exception();
            }

        } catch (Exception e) {
            request.setAttribute("message", "Transfer Failed: Invalid amount");
            request.setAttribute("fromAccount", fromAccStr);
            request.setAttribute("toAccount", toAccStr);
            request.setAttribute("amount", amountStr);

            loadData(request, user);
            request.getRequestDispatcher("customer/transfer.jsp").forward(request, response);
            return;
        }

        AccountDAO accountDAO = new AccountDAO();

        if (accountDAO.isFrozen(fromAccount)) {
            request.setAttribute("message", "Transfer Failed: Account is Frozen");

            request.setAttribute("fromAccount", fromAccStr);
            request.setAttribute("toAccount", toAccStr);
            request.setAttribute("amount", amountStr);

            loadData(request, user);
            request.getRequestDispatcher("customer/transfer.jsp").forward(request, response);
            return;
        }

        TransactionDAO dao = new TransactionDAO();
        String result = dao.transferMoney(fromAccount, toAccount, amount);

        if (result.equals("SUCCESS")) {
            request.setAttribute("message", "Transfer Successful");
            request.setAttribute("fromAccount", null);
            request.setAttribute("toAccount", "");
            request.setAttribute("amount", "");

        } else {
            request.setAttribute("message", "Transfer Failed: " + result);
            request.setAttribute("fromAccount", fromAccStr);
            request.setAttribute("toAccount", toAccStr);
            request.setAttribute("amount", amountStr);
        }

        loadData(request, user);
        request.getRequestDispatcher("customer/transfer.jsp").forward(request, response);
    }
}
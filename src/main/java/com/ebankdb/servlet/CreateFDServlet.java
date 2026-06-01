package com.ebankdb.servlet;

import com.ebankdb.dao.AccountDAO;
import com.ebankdb.dao.CustomerDAO;
import com.ebankdb.dao.FixedDepositDAO;
import com.ebankdb.model.User;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.sql.Date;
import java.time.LocalDate;
import java.time.Period;
import java.time.temporal.ChronoUnit;

@WebServlet("/createFD")
public class CreateFDServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        int userId = user.getUserId();

        CustomerDAO customerDAO = new CustomerDAO();
        int customerId = customerDAO.getCustomerIdByUserId(userId);

        int accountId = Integer.parseInt(request.getParameter("accountId"));
        String amountStr = request.getParameter("amount");
        String maturityStr = request.getParameter("maturity");

        BigDecimal amount;
        Date maturity;

        try {
            amount = new BigDecimal(amountStr);

            if(amount.compareTo(BigDecimal.ZERO) <= 0){
                request.setAttribute("error", "Invalid amount (must be greater than 0)");
                request.setAttribute("accountId", accountId);
                request.getRequestDispatcher("customer/createFD.jsp").forward(request, response);
                return;
            }

        } catch (Exception e) {
            request.setAttribute("error", "Invalid amount");
            request.setAttribute("accountId", accountId);
            request.getRequestDispatcher("customer/createFD.jsp").forward(request, response);
            return;
        }

        try {
            maturity = Date.valueOf(maturityStr);

            LocalDate today = LocalDate.now();
            LocalDate maturityDate = maturity.toLocalDate();

            if(maturityDate.isBefore(today)){
                request.setAttribute("error", "Maturity date cannot be in the past");
                request.setAttribute("accountId", accountId);
                request.getRequestDispatcher("customer/createFD.jsp").forward(request, response);
                return;
            }

        } catch (Exception e) {
            request.setAttribute("error", "Invalid maturity date");
            request.setAttribute("accountId", accountId);
            request.getRequestDispatcher("customer/createFD.jsp").forward(request, response);
            return;
        }

        AccountDAO accountDAO = new AccountDAO();

        if (accountDAO.isClosed(accountId)) {
            request.setAttribute("error", "Account is Closed");
            request.setAttribute("accountId", accountId);
            request.getRequestDispatcher("customer/createFD.jsp").forward(request, response);
            return;
        }

        if (accountDAO.isFrozen(accountId)) {
            request.setAttribute("error", "Account is Frozen. Cannot create FD");
            request.setAttribute("accountId", accountId);
            request.getRequestDispatcher("customer/createFD.jsp").forward(request, response);
            return;
        }

        BigDecimal balance = accountDAO.getBalance(accountId);

        if(balance.compareTo(amount) < 0){
            request.setAttribute("error", "Insufficient balance to create FD");
            request.setAttribute("accountId", accountId);
            request.getRequestDispatcher("customer/createFD.jsp").forward(request, response);
            return;
        }

        LocalDate startDate = LocalDate.now();
        LocalDate maturityDate = maturity.toLocalDate();

        long days = ChronoUnit.DAYS.between(startDate, maturityDate);
        long months = days / 30; // Approximate months

        double interestRate;

        if(months <= 6){
            interestRate = 5.0;
        } else if(months <= 12){
            interestRate = 6.0;
        } else if(months <= 24){
            interestRate = 7.0;
        } else if(months <= 36){
            interestRate = 7.5;
        } else {
            interestRate = 8.0;
        }

        double years = days / 365.0;
        BigDecimal interestRateDecimal = BigDecimal.valueOf(interestRate / 100.0);
        BigDecimal interestAmount = amount.multiply(interestRateDecimal).multiply(BigDecimal.valueOf(years));
        BigDecimal maturityAmount = amount.add(interestAmount).setScale(2, RoundingMode.HALF_UP);

        FixedDepositDAO dao = new FixedDepositDAO();
        boolean success = dao.createFD(customerId, accountId, amount, interestRate, maturityAmount, maturity);

        if(success){
            // Deduct amount from account balance
            accountDAO.updateBalance(accountId, balance.subtract(amount));
            response.sendRedirect("viewFDs");
        } else {
            request.setAttribute("error", "Error creating FD");
            request.setAttribute("accountId", accountId);
            request.getRequestDispatcher("customer/createFD.jsp").forward(request, response);
        }
    }
}
package com.ebankdb.servlet;

import com.ebankdb.dao.AccountDAO;
import com.ebankdb.dao.CustomerDAO;
import com.ebankdb.dao.FixedDepositDAO;

import com.ebankdb.model.User;
import com.oracle.wls.shaded.org.apache.xml.dtm.ref.DTMAxisIterNodeList;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/breakFD")
public class BreakFDServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int fdId = Integer.parseInt(request.getParameter("fdId"));
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        CustomerDAO customerDAO = new CustomerDAO();
        int customerId = customerDAO.getCustomerIdByUserId(user.getUserId());

        FixedDepositDAO fdDAO = new FixedDepositDAO();
        int accountId = fdDAO.getAccountIdByFdId(fdId);

        AccountDAO accountDAO = new AccountDAO();

        // ACCOUNT CLOSED
        if(accountDAO.isClosed(accountId)){
            request.setAttribute("error", "Account is Closed. Cannot break FD.");
            request.setAttribute("fds", fdDAO.getFDsByCustomer(customerId));
            request.getRequestDispatcher("customer/fixedDeposits.jsp").forward(request, response);
            return;
        }

        // ACCOUNT FROZEN
        if(accountDAO.isFrozen(accountId)){
            request.setAttribute("error", "Account is Frozen. Cannot break FD.");
            request.setAttribute("fds", fdDAO.getFDsByCustomer(customerId));
            request.getRequestDispatcher("customer/fixedDeposits.jsp").forward(request, response);
            return;
        }

        boolean success = fdDAO.breakFD(fdId);

        if(success){
            response.sendRedirect("viewFDs");
        } else {
            request.setAttribute("error", "Error breaking FD");
            request.setAttribute("fds", fdDAO.getFDsByCustomer(customerId));
            request.getRequestDispatcher("customer/fixedDeposits.jsp").forward(request, response);
        }
    }
}
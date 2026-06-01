package com.ebankdb.servlet;

import com.ebankdb.dao.BeneficiaryDAO;
import com.ebankdb.dao.CustomerDAO;
import com.ebankdb.model.Beneficiary;
import com.ebankdb.model.User;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;

@WebServlet("/viewBeneficiaries")
public class ViewBeneficiariesServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();

        User user = (User) session.getAttribute("user");
        int userId = user.getUserId();

        CustomerDAO customerDAO = new CustomerDAO();
        int customerId = customerDAO.getCustomerIdByUserId(userId);

        BeneficiaryDAO dao = new BeneficiaryDAO();
        List<Beneficiary> list = dao.getBeneficiariesByCustomer(customerId);

        request.setAttribute("beneficiaries", list);
        RequestDispatcher rd = request.getRequestDispatcher("customer/beneficiaries.jsp");
        rd.forward(request, response);
    }
}
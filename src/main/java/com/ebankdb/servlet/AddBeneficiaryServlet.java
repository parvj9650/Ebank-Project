package com.ebankdb.servlet;

import com.ebankdb.dao.BeneficiaryDAO;
import com.ebankdb.dao.CustomerDAO;
import com.ebankdb.model.User;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/addBeneficiary")
public class AddBeneficiaryServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();

        User user = (User) session.getAttribute("user");
        int userId = user.getUserId();

        CustomerDAO customerDAO = new CustomerDAO();
        int customerId = customerDAO.getCustomerIdByUserId(userId);

        String name = request.getParameter("name");
        String accountNumber = request.getParameter("accountNumber");

        BeneficiaryDAO dao = new BeneficiaryDAO();
        String result = dao.addBeneficiary(customerId, name, accountNumber);

        if(result.equals("SUCCESS")){
            response.sendRedirect("viewBeneficiaries");
        } else {
            request.setAttribute("error", "Error: " + result);
            RequestDispatcher rd = request.getRequestDispatcher("customer/addBeneficiary.jsp");
            rd.forward(request,response);
        }
    }
}
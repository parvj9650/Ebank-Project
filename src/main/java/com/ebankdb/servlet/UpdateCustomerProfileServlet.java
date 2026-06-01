package com.ebankdb.servlet;

import com.ebankdb.dao.CustomerDAO;
import com.ebankdb.model.Customer;
import com.ebankdb.model.User;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.time.LocalDate;
import java.time.Period;

@WebServlet("/updateCustomerProfile")
public class UpdateCustomerProfileServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        String name = request.getParameter("name");
        String address = request.getParameter("address");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String dobStr = request.getParameter("dob");

        // NAME VALIDATION
        if(name == null || !name.matches("[a-zA-Z ]+")){
            error(request, response, "Name must contain only alphabets");
            return;
        }

        // PHONE VALIDATION
        if(phone == null || !phone.matches("\\d{10}")){
            error(request, response, "Phone must be 10 digits");
            return;
        }

        LocalDate dob;
        try{
            dob = LocalDate.parse(dobStr);
        } catch(Exception e){
            error(request, response, "Invalid date");
            return;
        }

        // AGE CHECK
        if(Period.between(dob, LocalDate.now()).getYears() < 18){
            error(request, response, "Must be 18+");
            return;
        }

        CustomerDAO dao = new CustomerDAO();
        dao.updateCustomerProfile(user.getUserId(), name, address, email, phone, dob);

        Customer updatedCustomer = dao.getCustomerByUserId(user.getUserId());

        request.setAttribute("customer", updatedCustomer);
        request.setAttribute("success", "Profile updated successfully");

        request.getRequestDispatcher("customer/editProfile.jsp").forward(request, response);
    }

    private void error(HttpServletRequest request, HttpServletResponse response, String msg) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        CustomerDAO dao = new CustomerDAO();
        Customer customer = dao.getCustomerByUserId(user.getUserId());

        request.setAttribute("customer", customer);
        request.setAttribute("error", msg);

        request.getRequestDispatcher("customer/editProfile.jsp").forward(request, response);
    }
}
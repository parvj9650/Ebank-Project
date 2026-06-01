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

@WebServlet("/saveCustomerProfile")
public class SaveCustomerProfileServlet extends HttpServlet {
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
            request.setAttribute("error", "Name must contain only alphabets");
            request.getRequestDispatcher("customer/profile.jsp").forward(request, response);
            return;
        }

        // PHONE VALIDATION
        if(phone == null || !phone.matches("\\d{10}")){
            request.setAttribute("error", "Phone number must be exactly 10 digits");
            request.getRequestDispatcher("customer/profile.jsp").forward(request, response);
            return;
        }

        LocalDate dob;
        try{
            dob = LocalDate.parse(dobStr);
        } catch(Exception e){
            request.setAttribute("error", "Invalid date of birth");
            request.getRequestDispatcher("customer/profile.jsp").forward(request, response);
            return;
        }

        // AGE CHECK (18+)
        LocalDate today = LocalDate.now();

        if(Period.between(dob, today).getYears() < 18){
            request.setAttribute("error", "You must be at least 18 years old");
            request.getRequestDispatcher("customer/profile.jsp").forward(request, response);
            return;
        }

        if(dob.isAfter(today)){
            request.setAttribute("error", "Date of birth cannot be in the future");
            request.getRequestDispatcher("customer/profile.jsp").forward(request, response);
            return;
        }

        Customer customer = new Customer();
        customer.setUserId(user.getUserId());
        customer.setName(name);
        customer.setAddress(address);
        customer.setEmail(email);
        customer.setPhone(phone);
        customer.setDob(dob);

        CustomerDAO dao = new CustomerDAO();
        dao.saveCustomerProfile(customer);

        session.setAttribute("customer", customer);

        response.sendRedirect("customer/dashboard.jsp");
    }
}
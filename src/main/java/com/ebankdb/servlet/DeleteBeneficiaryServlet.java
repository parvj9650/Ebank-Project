package com.ebankdb.servlet;

import com.ebankdb.dao.BeneficiaryDAO;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/deleteBeneficiary")
public class DeleteBeneficiaryServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        BeneficiaryDAO dao = new BeneficiaryDAO();

        dao.deleteBeneficiary(id);

        response.sendRedirect("viewBeneficiaries");
    }
}
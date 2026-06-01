import com.ebankdb.dao.CustomerDAO;
import com.ebankdb.model.Customer;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;

@WebServlet("/customersWithoutAccounts")
public class CustomersWithoutAccountsServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request,HttpServletResponse response) throws ServletException, IOException {
        CustomerDAO dao = new CustomerDAO();
        List<Customer> customers = dao.getCustomersWithoutAccounts();
        request.setAttribute("customers", customers);

        RequestDispatcher rd = request.getRequestDispatcher("employee/createAccount.jsp");

        rd.forward(request, response);
    }
}
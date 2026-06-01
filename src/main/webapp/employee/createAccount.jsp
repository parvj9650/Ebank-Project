<%@ page import="java.util.List" %>
<%@ page import="com.ebankdb.model.Customer" %>
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Create Customer Account - eBankDB</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .container-custom {
            max-width: 1000px;
            margin: 0 auto;
            padding: 40px 20px;
        }

        .page-header {
            text-align: center;
            margin-bottom: 30px;
        }

        .page-header h2 {
            color: var(--dark);
            font-size: 28px;
        }

        .table-container {
            background: white;
            border-radius: var(--border-radius);
            padding: 20px;
            box-shadow: var(--shadow);
            overflow-x: auto;
        }

        table {
            width: 100%;
            border-collapse: collapse;
        }

        th {
            text-align: left;
            padding: 12px;
            background: #f8fafc;
            font-weight: 600;
            color: var(--dark);
            border-bottom: 2px solid #e2e8f0;
        }

        td {
            padding: 12px;
            border-bottom: 1px solid #e2e8f0;
        }

        tr:hover {
            background: #f8fafc;
        }

        .create-account-btn {
            background: linear-gradient(135deg, #14b8a6, #0d9488);
            color: white;
            padding: 8px 20px;
            border-radius: 8px;
            text-decoration: none;
            font-weight: 600;
            font-size: 13px;
            transition: all 0.3s;
            display: inline-flex;
            align-items: center;
            gap: 6px;
        }

        .create-account-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(20, 184, 166, 0.3);
            background: linear-gradient(135deg, #475569, #334155);
            text-decoration: none;
            color: white;
        }

        .back-btn {
            background: linear-gradient(135deg, #14b8a6, #0d9488);
            color: white;
            padding: 12px 28px;
            border-radius: 10px;
            text-decoration: none;
            font-weight: 600;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            transition: all 0.3s;
            font-size: 14px;
        }

        .back-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(100, 116, 139, 0.3);
            background: linear-gradient(135deg, #475569, #334155);
            text-decoration: none;
            color: white;
        }

        .bottom-buttons {
            display: flex;
            justify-content: center;
            margin-top: 30px;
        }

        .empty-state {
            text-align: center;
            padding: 60px 40px;
            color: #64748b;
        }

        .account-id {
            font-weight: 700;
            color: #14b8a6;
            font-size: 14px;
        }
    </style>
</head>
<body>

<div class="container-custom">
    <div class="page-header">
        <h2>🏦 Customers Without Accounts</h2>
    </div>

    <div class="table-container">
        <%
        List<Customer> customers = (List<Customer>) request.getAttribute("customers");

        if(customers != null && !customers.isEmpty()){
        %>
        <table>
            <thead>
                <tr>
                    <th>Customer ID</th>
                    <th>Name</th>
                    <th>Action</th>
                </tr>
            </thead>
            <tbody>
                <%
                for(Customer c : customers){
                %>
                    <tr>
                        <td><span class="account-id">#<%= c.getCustomerId() %></span></td>
                        <td><strong><%= c.getName() %></strong></td>
                        <td>
                            <a href="<%=request.getContextPath()%>/employeeCreateAccount?customerId=<%=c.getCustomerId()%>"
                               class="create-account-btn">
                                ➕ Create Account
                            </a>
                        </td>
                    </tr>
                <%
                }
                %>
            </tbody>
        </table>

        <% } else { %>
            <div class="empty-state">
                <p>📭 No customers without accounts found</p>
                <p style="font-size: 13px; margin-top: 10px;">All customers already have accounts.</p>
            </div>
        <% } %>
    </div>

    <div class="bottom-buttons">
        <a href="employee/dashboard.jsp" class="back-btn">← Back to Dashboard</a>
    </div>
</div>

</body>
</html>
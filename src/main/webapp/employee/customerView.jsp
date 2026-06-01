<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*" %>
<%@ page import="java.math.BigDecimal" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Customer Details - eBankDB</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .search-section {
            background: white;
            padding: 20px;
            border-radius: var(--border-radius);
            margin-bottom: 25px;
            box-shadow: var(--shadow);
        }

        .search-form {
            display: flex;
            gap: 15px;
            align-items: flex-end;
            flex-wrap: wrap;
        }

        .search-form .form-group {
            flex: 1;
            min-width: 200px;
            margin-bottom: 0;
        }

        .search-form label {
            margin-bottom: 5px;
            font-size: 13px;
            font-weight: 500;
            color: var(--dark);
            display: block;
        }

        .search-form input {
            width: 100%;
            padding: 10px 12px;
            border: 1px solid #e2e8f0;
            border-radius: 8px;
            font-size: 14px;
            transition: all 0.3s;
        }

        .search-form input:focus {
            outline: none;
            border-color: #14b8a6;
            box-shadow: 0 0 0 3px rgba(20, 184, 166, 0.1);
        }

        .btn-search {
            background: linear-gradient(135deg, #14b8a6, #0d9488);
            color: white;
            padding: 10px 24px;
            border-radius: 8px;
            border: none;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
            font-size: 14px;
        }

        .btn-search:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(20, 184, 166, 0.3);
            background: linear-gradient(135deg, #64748b, #475569);
        }

        .show-all-btn {
            background: linear-gradient(135deg, #64748b, #475569);
            color: white;
            padding: 10px 24px;
            border-radius: 8px;
            text-decoration: none;
            font-weight: 600;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            transition: all 0.3s;
            font-size: 14px;
        }

        .show-all-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(100, 116, 139, 0.3);
            background: linear-gradient(135deg, #475569, #334155);
            text-decoration: none;
            color: white;
        }

        .badge-no-account {
            background: #fed7aa;
            color: #92400e;
            padding: 4px 10px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
            display: inline-block;
        }

        .badge-na {
            background: #f1f5f9;
            color: #64748b;
            padding: 4px 10px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
            display: inline-block;
        }

        .balance-positive {
            color: #065f46;
            font-weight: bold;
        }

        .account-id {
            font-weight: 700;
            color: #14b8a6;
            font-size: 14px;
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
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            font-size: 14px;
            border: none;
            cursor: pointer;
        }

        .back-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(100, 116, 139, 0.3);
            background: linear-gradient(135deg, #64748b, #475569);
            text-decoration: none;
            color: white;
        }

        .bottom-buttons {
            display: flex;
            justify-content: center;
            margin-top: 30px;
        }

        .page-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 25px;
            flex-wrap: wrap;
            gap: 15px;
        }

        .page-header h2 {
            margin: 0;
            color: var(--dark);
        }

        .empty-state {
            text-align: center;
            padding: 60px 40px;
            color: #64748b;
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
    </style>
</head>
<body>

<div class="container">
    <div class="page-header">
        <h2>👥 Customer Details</h2>
    </div>

    <div class="search-section">
        <form method="get" action="employeeCustomerView" class="search-form">
            <div class="form-group">
                <label>🔍 Search Customer ID</label>
                <input type="text" name="customerId" placeholder="Enter Customer ID">
            </div>
            <button type="submit" class="btn-search">🔍 Search</button>
            <a href="employeeCustomerView?action=showAll" class="show-all-btn">Show All Customers</a>
        </form>
    </div>

    <div class="table-container">
        <%
        List<Map<String,Object>> list = (List<Map<String,Object>>) request.getAttribute("data");

        if(list != null && !list.isEmpty()){
        %>
        <table>
            <thead>
                <tr>
                    <th>Customer ID</th>
                    <th>Name</th>
                    <th>Email</th>
                    <th>Phone</th>
                    <th>Account ID</th>
                    <th>Type</th>
                    <th>Balance</th>
                    <th>Status</th>
                    <th>Branch</th>
                </tr>
            </thead>
            <tbody>
                <%
                for(Map<String,Object> row : list){
                    Object accountId = row.get("account_id");
                    Object accountType = row.get("account_type");
                    Object balance = row.get("balance");
                    Object accountStatus = row.get("account_status");
                    Object branchName = row.get("branch_name");
                %>
                    <tr>
                        <td><span class="account-id">#<%= row.get("customer_id") %></span></td>
                        <td><strong><%= row.get("customer_name") %></strong></td>
                        <td><%= row.get("email") %></dt>
                        <td><%= row.get("phone") %></dt>
                        <td>
                            <% if(accountId != null && !"No Account".equals(accountId)) { %>
                                <span class="account-id">#<%= accountId %></span>
                            <% } else { %>
                                <span class="badge-no-account">No Account</span>
                            <% } %>
                        </dt>
                        <td>
                            <% if(accountType != null && !"N/A".equals(accountType)) { %>
                                <%= accountType %>
                            <% } else { %>
                                <span class="badge-na">N/A</span>
                            <% } %>
                        </dt>
                        <td>
                            <% if(balance != null) {
                                BigDecimal bal = new BigDecimal(balance.toString());
                            %>
                                <strong class="balance-positive">₹ <%= String.format("%,.2f", bal) %></strong>
                            <% } else { %>
                                ₹ 0
                            <% } %>
                        </dt>
                        <td>
                            <% if(accountStatus != null && !"No Account".equals(accountStatus)) {
                                if("Active".equals(accountStatus)) { %>
                                    <span class="status-active">Active</span>
                                <% } else if("Frozen".equals(accountStatus)) { %>
                                    <span class="status-frozen">Frozen</span>
                                <% } else { %>
                                    <span class="status-closed">Closed</span>
                                <% }
                            } else { %>
                                <span class="badge-na">No Account</span>
                            <% } %>
                        </td>
                        <td>
                            <% if(branchName != null && !"N/A".equals(branchName)) { %>
                                <%= branchName %>
                            <% } else { %>
                                <span class="badge-na">N/A</span>
                            <% } %>
                        </dt>
                    </tr>
                <%
                }
                %>
            </tbody>
        </table>

        <% } else { %>
            <div class="empty-state">
                <p>📭 No customer data available</p>
            </div>
        <% } %>
    </div>

    <div class="bottom-buttons">
        <a href="employee/dashboard.jsp" class="back-btn">← Back to Dashboard</a>
    </div>
</div>

</body>
</html>
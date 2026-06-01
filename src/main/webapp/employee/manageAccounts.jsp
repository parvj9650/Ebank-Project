<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.ebankdb.model.Account" %>
<%@ page import="java.math.BigDecimal" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Manage Accounts - eBankDB</title>
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
            background: linear-gradient(135deg, #475569, #334155);
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

        .action-link {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 5px;
            padding: 6px 16px;
            border-radius: 6px;
            text-decoration: none;
            font-size: 12px;
            font-weight: 600;
            transition: all 0.3s;
            min-width: 70px;
        }

        .action-freeze {
            background: linear-gradient(135deg, #f59e0b, #d97706);
            color: white;
        }

        .action-freeze:hover {
            transform: translateY(-1px);
            box-shadow: 0 2px 8px rgba(245, 158, 11, 0.3);
            background: linear-gradient(135deg, #475569, #334155);
            text-decoration: none;
            color: white;
        }

        .action-activate {
            background: linear-gradient(135deg, #14b8a6, #0d9488);
            color: white;
        }

        .action-activate:hover {
            transform: translateY(-1px);
            box-shadow: 0 2px 8px rgba(20, 184, 166, 0.3);
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
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            font-size: 14px;
            border: none;
            cursor: pointer;
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

        .error-message {
            background: #fee2e2;
            color: #991b1b;
            padding: 12px 20px;
            border-radius: 8px;
            margin-bottom: 20px;
            border-left: 4px solid #ef4444;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .account-id {
            font-weight: 700;
            color: #14b8a6;
            font-size: 14px;
        }

        .balance-positive {
            color: #065f46;
            font-weight: bold;
        }

        .action-buttons {
            display: flex;
            gap: 10px;
            flex-wrap: wrap;
        }

        /* Fixed status badge sizes */
        .status-active, .status-frozen {
            display: inline-block;
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
            text-align: center;
            min-width: 70px;
        }

        .status-active {
            background: #d1fae5;
            color: #065f46;
        }

        .status-frozen {
            background: #fed7aa;
            color: #92400e;
        }
    </style>
</head>
<body>

<div class="container">
    <div class="page-header">
        <h2>⚙️ Manage Accounts</h2>
    </div>

    <%
    String currentAccountId = request.getParameter("accountId");
    String error = (String) request.getAttribute("error");
    if(error != null && error.equals("invalidId")) {
    %>
        <div class="error-message">
            <span>⚠</span> Invalid Account ID format. Please enter a valid number.
        </div>
    <%
    }
    %>

    <div class="search-section">
        <form method="get" action="manageAccounts" class="search-form">
            <div class="form-group">
                <label>🔍 Search Account ID</label>
                <input type="text" id="accountIdSearch" name="accountId"
                       value="<%= currentAccountId != null ? currentAccountId : "" %>"
                       placeholder="Enter Account ID">
            </div>
            <button type="submit" class="btn-search">🔍 Search</button>
            <a href="manageAccounts?action=showAll" class="show-all-btn">Show All Accounts</a>
        </form>
    </div>

    <div class="table-container">
        <%
        List<Account> accounts = (List<Account>) request.getAttribute("accounts");

        if(accounts != null && !accounts.isEmpty()){
        %>
        <table>
            <thead>
                <tr>
                    <th>Account ID</th>
                    <th>Customer ID</th>
                    <th>Balance</th>
                    <th>Status</th>
                    <th>Action</th>
                </tr>
            </thead>
            <tbody>
                <%
                for(Account a : accounts){
                    boolean isActive = "Active".equals(a.getStatus());
                %>
                    <tr>
                        <td><span class="account-id">#<%= a.getAccountId() %></span></td>
                        <td>#<%= a.getCustomerId() %></dt>
                        <td class="balance-positive">₹ <%= String.format("%,.2f", a.getBalance()) %></dt>
                        <td>
                            <% if(isActive) { %>
                                <span class="status-active">Active</span>
                            <% } else { %>
                                <span class="status-frozen">Frozen</span>
                            <% } %>
                        </dt>
                        <td>
                            <div class="action-buttons">
                                <a href="employeeAccountAction?action=freeze&accountId=<%=a.getAccountId()%>&currentSearchId=<%= currentAccountId != null ? currentAccountId : "" %>"
                                   class="action-link action-freeze"
                                   onclick="return confirm('Are you sure you want to freeze account #<%= a.getAccountId() %>?')">
                                   Freeze
                                </a>
                                <a href="employeeAccountAction?action=activate&accountId=<%=a.getAccountId()%>&currentSearchId=<%= currentAccountId != null ? currentAccountId : "" %>"
                                   class="action-link action-activate"
                                   onclick="return confirm('Are you sure you want to activate account #<%= a.getAccountId() %>?')">
                                    Activate
                                </a>
                            </div>
                        </dt>
                    </tr>
                <%
                }
                %>
            </tbody>
        </table>

        <% } else { %>
            <div class="empty-state">
                <p>📭 No accounts found</p>
                <p style="font-size: 13px; margin-top: 10px;">Try searching for a specific account ID or click "Show All Accounts"</p>
            </div>
        <% } %>
    </div>

    <div class="bottom-buttons">
        <a href="employee/dashboard.jsp" class="back-btn">← Back to Dashboard</a>
    </div>
</div>

</body>
</html>
<%@ page import="java.util.List" %>
<%@ page import="com.ebankdb.model.Account" %>
<%@ page import="java.math.BigDecimal" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<html>
<head>
    <meta charset="UTF-8">
    <title>Your Accounts - eBankDB</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .action-buttons {
            display: flex;
            gap: 8px;
            flex-wrap: wrap;
        }
        .action-btn {
            text-decoration: none;
            padding: 6px 12px;
            border-radius: 6px;
            font-size: 12px;
            transition: all 0.3s;
            display: inline-flex;
            align-items: center;
            gap: 5px;
            white-space: nowrap;
        }
        .action-btn:hover {
            transform: translateY(-1px);
        }
        .btn-transactions {
            background: linear-gradient(135deg, #14b8a6, #0d9488);
            color: white;
        }
        .btn-transactions:hover {
            background: linear-gradient(135deg, #0d9488, #0f766e);
        }
        .btn-fd {
            background: linear-gradient(135deg, #f59e0b, #d97706);
            color: white;
        }
        .btn-fd:hover {
            background: linear-gradient(135deg, #d97706, #b45309);
        }
        .btn-addfunds {
            background: linear-gradient(135deg, #3b82f6, #2563eb);
            color: white;
        }
        .btn-addfunds:hover {
            background: linear-gradient(135deg, #2563eb, #1d4ed8);
        }
        .balance-positive {
            color: #065f46;
            font-weight: bold;
            font-size: 16px;
        }
        .empty-state {
            text-align: center;
            padding: 60px 40px;
            color: #64748b;
        }
        .page-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 25px;
            flex-wrap: wrap;
            gap: 15px;
        }
        .create-btn {
            background: linear-gradient(135deg, #14b8a6, #0d9488);
            color: white;
            padding: 12px 24px;
            border-radius: 10px;
            text-decoration: none;
            font-weight: 600;
            transition: all 0.3s;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }
        .create-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(20, 184, 166, 0.3);
            background: linear-gradient(135deg, #64748b, #475569);
        }
        .back-link {
            display: inline-block;
            margin-top: 25px;
            color: #14b8a6;
            text-decoration: none;
            font-weight: 500;
        }
        .back-link:hover {
            text-decoration: underline;
        }
        .success-alert {
            background: #d1fae5;
            border-left: 4px solid #14b8a6;
            padding: 12px 20px;
            border-radius: 8px;
            margin-bottom: 20px;
            color: #065f46;
        }
        .account-type {
            display: inline-block;
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
        }
        .type-savings {
            background: #dbeafe;
            color: #1e40af;
        }
        .type-current {
            background: #fed7aa;
            color: #92400e;
        }
        .accounts-summary {
            background: #f1f5f9;
            padding: 12px 20px;
            border-radius: 8px;
            margin-bottom: 20px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 15px;
        }
        .summary-item {
            font-size: 14px;
        }
        .summary-label {
            color: #64748b;
            margin-right: 8px;
        }
        .summary-value {
            font-weight: 600;
            color: #0f172a;
        }
        .account-id {
            font-weight: 700;
            color: #14b8a6;
            font-size: 15px;
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
            gap: 8px;
            transition: all 0.3s;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            font-size: 14px;
            border: none;
            cursor: pointer;
        }

        .back-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(37, 99, 235, 0.3);
            background: linear-gradient(135deg, #64748b, #475569);
        }
    </style>
</head>
<body>

<div class="container">
    <div class="page-header">
        <h2>🏦 Your Accounts</h2>
        <a href="createAccount" class="create-btn">➕ Create New Account</a>
    </div>

    <% if(request.getParameter("success") != null) { %>
        <div class="success-alert">
            ✓ Funds added successfully!
        </div>
    <% } %>

    <div class="table-container">
        <%
        List<Account> accounts = (List<Account>) request.getAttribute("accounts");
        if(accounts != null && !accounts.isEmpty()) {
            BigDecimal totalBalance = BigDecimal.ZERO;
            int activeCount = 0;
            for(Account acc : accounts) {
                totalBalance = totalBalance.add(acc.getBalance());
                if("Active".equals(acc.getStatus())) {
                    activeCount++;
                }
            }
        %>

        <div class="accounts-summary">
            <div class="summary-item">
                <span class="summary-label">📊 Total Accounts:</span>
                <span class="summary-value"><%= accounts.size() %></span>
            </div>
            <div class="summary-item">
                <span class="summary-label">💰 Total Balance:</span>
                <span class="summary-value">₹ <%= String.format("%,.2f", totalBalance) %></span>
            </div>
            <div class="summary-item">
                <span class="summary-label">✅ Active Accounts:</span>
                <span class="summary-value"><%= activeCount %></span>
            </div>
        </div>

        <table>
            <thead>
                <tr>
                    <th>Account ID</th>
                    <th>Balance</th>
                    <th>Type</th>
                    <th>Status</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
            <% for(Account acc : accounts) { %>
                <tr>
                    <td><span class="account-id">#<%= acc.getAccountId() %></span></td>
                    <td class="balance-positive">₹ <%= String.format("%,.2f", acc.getBalance()) %></dt>
                    <td>
                        <% if("Savings".equals(acc.getAccountType())) { %>
                            <span class="account-type type-savings">💰 Savings</span>
                        <% } else { %>
                            <span class="account-type type-current">💼 Current</span>
                        <% } %>
                    </dt>
                    <td>
                        <% if("Active".equals(acc.getStatus())) { %>
                            <span class="status-active">● Active</span>
                        <% } else if("Frozen".equals(acc.getStatus())) { %>
                            <span class="status-frozen">❄ Frozen</span>
                        <% } else { %>
                            <span class="status-closed">✕ Closed</span>
                        <% } %>
                    </dt>
                    <td class="action-buttons">
                        <a href="<%= request.getContextPath() %>/viewTransactions?accountId=<%= acc.getAccountId() %>"
                           class="action-btn btn-transactions">📋 Transactions</a>
                        <a href="<%= request.getContextPath() %>/customer/createFD.jsp?accountId=<%= acc.getAccountId() %>"
                           class="action-btn btn-fd">📈 Create FD</a>
                        <a href="<%= request.getContextPath() %>/addFunds?accountId=<%= acc.getAccountId() %>"
                           class="action-btn btn-addfunds">💰 Add Funds</a>
                    </dt>
                </tr>
            <% } %>
            </tbody>
        </table>

        <% } else { %>
            <div class="empty-state">
                <p>📭 You don't have any accounts yet.</p>
                <a href="createAccount" class="create-btn">Create your first account →</a>
            </div>
        <% } %>
    </div>
    <br>
    <div class="bottom-buttons">
        <a href="<%= request.getContextPath() %>/customer/dashboard.jsp" class="back-btn">
            ← Back to Dashboard
        </a>
    </div>
</div>

</body>
</html>
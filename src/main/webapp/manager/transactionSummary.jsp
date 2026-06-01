<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.ebankdb.model.Transaction" %>
<%@ page import="java.math.BigDecimal" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Transaction Summary - Manager Panel</title>
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

        .txn-type-badge {
            display: inline-block;
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
        }

        .txn-credit-summary {
            background: #d1fae5;
            color: #065f46;
        }

        .txn-debit-summary {
            background: #fee2e2;
            color: #991b1b;
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

        .account-id {
            font-weight: 700;
            color: #14b8a6;
            font-size: 14px;
        }

        .amount-positive {
            color: #065f46;
            font-weight: bold;
        }
    </style>
</head>
<body>

<div class="container">
    <div class="page-header">
        <h2>📊 Transaction Summary</h2>
    </div>

    <div class="search-section">
        <form method="get" action="<%= request.getContextPath() %>/transactionSummary" class="search-form">
            <div class="form-group">
                <label>🔍 Search Account ID</label>
                <input type="text" name="accountId"
                       value="<%= request.getParameter("accountId") != null ? request.getParameter("accountId") : "" %>"
                       placeholder="Enter Account ID">
            </div>
            <button type="submit" class="btn-search">🔍 Search</button>
            <a href="<%= request.getContextPath() %>/transactionSummary?action=showAll" class="show-all-btn">Show All Accounts</a>
        </form>
    </div>

    <div class="table-container">
        <%
        String error = (String) request.getAttribute("error");
        List<Transaction> transactions = (List<Transaction>) request.getAttribute("transactions");

        if(transactions != null && !transactions.isEmpty()){
        %>
        <table>
            <thead>
                <tr>
                    <th>Account ID</th>
                    <th>Transaction Type</th>
                    <th>Total Transactions</th>
                    <th>Total Amount</th>
                </tr>
            </thead>
            <tbody>
                <%
                for(Transaction t : transactions){
                    String txnClass = ("Credit".equals(t.getTxnType()) || "Deposit".equals(t.getTxnType())) ? "txn-credit-summary" : "txn-debit-summary";
                %>
                    <tr>
                        <td><span class="account-id">#<%= t.getAccountId() %></span></td>
                        <td><span class="txn-type-badge <%= txnClass %>"><%= t.getTxnType() %></span></td>
                        <td><strong><%= t.getTransactionCount() %></strong> </dt>
                        <td class="amount-positive">₹ <%= String.format("%,.2f", t.getAmount()) %></dt>
                    </tr>
                <%
                }
                %>
            </tbody>
        </table>

        <% } else if(error != null && error.equals("invalidId")) { %>
            <div class="empty-state">
                <p>⚠ Invalid Account ID format. Please enter a valid number.</p>
            </div>
        <% } else if(error != null && error.equals("noTransactions")) { %>
            <div class="empty-state">
                <p>📭 No transaction summary available</p>
                <p style="font-size: 13px; margin-top: 10px;">Try searching for a specific account ID or click "Show All Accounts"</p>
            </div>
        <% } %>
    </div>

    <div class="bottom-buttons">
        <a href="manager/dashboard.jsp" class="back-btn">← Back to Dashboard</a>
    </div>
</div>

</body>
</html>
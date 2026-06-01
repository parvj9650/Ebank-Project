<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.ebankdb.model.Transaction" %>
<%@ page import="com.ebankdb.model.User" %>
<%@ page import="java.math.BigDecimal" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>All Transactions - Manager Panel</title>
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

        .filter-group {
            display: flex;
            flex-direction: column;
            gap: 5px;
        }

        .filter-group label {
            font-size: 13px;
            font-weight: 500;
            color: var(--dark);
        }

        .filter-group select {
            padding: 10px 12px;
            border: 1px solid #e2e8f0;
            border-radius: 8px;
            font-size: 14px;
            background: white;
            cursor: pointer;
        }

        .filter-group select:focus {
            outline: none;
            border-color: #14b8a6;
            box-shadow: 0 0 0 3px rgba(20, 184, 166, 0.1);
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

        .txn-credit {
            color: #065f46;
            font-weight: bold;
        }

        .txn-debit {
            color: #991b1b;
            font-weight: bold;
        }

        .txn-type {
            display: inline-block;
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
        }

        .txn-deposit { background: #d1fae5; color: #065f46; }
        .txn-withdrawal { background: #fee2e2; color: #991b1b; }
        .txn-transfer { background: #fed7aa; color: #92400e; }

        .summary {
            background: #f1f5f9;
            padding: 15px;
            border-radius: 12px;
            margin-bottom: 20px;
            display: flex;
            justify-content: space-between;
            flex-wrap: wrap;
            gap: 15px;
        }

        .back-btn {
            background: linear-gradient(135deg, #0d9488, #0f766e);
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

        .status-success {
            background: #d1fae5;
            color: #065f46;
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
            display: inline-block;
        }

        .status-failed {
            background: #fee2e2;
            color: #991b1b;
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
            display: inline-block;
        }
    </style>
</head>
<body>

<%
User user = (User) session.getAttribute("user");
String contextPath = request.getContextPath();
%>

<div class="container">
    <div class="page-header">
        <h2>📋 All Transactions</h2>
    </div>

    <div class="search-section">
        <form method="get" action="<%= contextPath %>/viewAllTransactions" class="search-form">
            <div class="filter-group">
                <label>Status:</label>
                <select name="status">
                    <option value="open" <%= "open".equals(request.getParameter("status")) ? "selected" : "" %>>
                        Open Accounts
                    </option>
                    <option value="closed" <%= "closed".equals(request.getParameter("status")) ? "selected" : "" %>>
                        Closed Accounts
                    </option>
                </select>
            </div>

            <div class="form-group">
                <label>🔍 Search Account ID</label>
                <input type="text" name="accountId"
                       value="<%= request.getParameter("accountId") != null ? request.getParameter("accountId") : "" %>"
                       placeholder="Enter Account ID">
            </div>
            <button type="submit" class="btn-search">🔍 Search</button>
            <a href="<%= contextPath %>/viewAllTransactions?action=showAll&status=<%= request.getParameter("status") != null ? request.getParameter("status") : "open" %>" class="show-all-btn">Show All Accounts</a>
        </form>
    </div>

    <div class="table-container">
        <%
        String error = (String) request.getAttribute("error");
        List<Transaction> transactions = (List<Transaction>) request.getAttribute("transactions");

        if(transactions != null && !transactions.isEmpty()) {
            // Calculate summary
            BigDecimal credits = BigDecimal.ZERO;
            BigDecimal debits = BigDecimal.ZERO;
            for(Transaction t : transactions) {
                if("Credit".equals(t.getTxnType()) || "Deposit".equals(t.getTxnType())) {
                    credits = credits.add(t.getAmount());
                } else {
                    debits = debits.add(t.getAmount());
                }
            }

            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd-MMM-yyyy HH:mm");
        %>

        <div class="summary">
            <div>📊 Total Transactions: <strong><%= transactions.size() %></strong></div>
            <div>💰 Total Credits: <strong class="txn-credit">₹ <%= String.format("%,.2f", credits) %></strong></div>
            <div>💸 Total Debits: <strong class="txn-debit">₹ <%= String.format("%,.2f", debits) %></strong></div>
        </div>

        <table>
            <thead>
                <tr>
                    <th>Transaction ID</th>
                    <th>Account</th>
                    <th>Type</th>
                    <th>Amount</th>
                    <th>Date</th>
                    <th>Status</th>
                </tr>
            </thead>
            <tbody>
                <%
                for(Transaction t : transactions){
                    String txnClass = "";
                    if("Deposit".equals(t.getTxnType())) txnClass = "txn-deposit";
                    else if("Withdrawal".equals(t.getTxnType())) txnClass = "txn-withdrawal";
                    else txnClass = "txn-transfer";

                    String formattedDate = t.getTxnDate() != null ? t.getTxnDate().format(formatter) : "-";
                    String amountClass = ("Credit".equals(t.getTxnType()) || "Deposit".equals(t.getTxnType())) ? "txn-credit" : "txn-debit";
                    boolean isSuccess = t.getStatus() != null && t.getStatus().equalsIgnoreCase("Success");
                %>
                    <tr>
                        <td><span class="account-id">#<%= t.getTxnId() %></span></td>
                        <td>#<%= t.getAccountId() %></dt>
                        <td><span class="txn-type <%= txnClass %>"><%= t.getTxnType() %></span></dt>
                        <td class="<%= amountClass %>">₹ <%= String.format("%,.2f", t.getAmount()) %></dt>
                        <td><%= formattedDate %></dt>
                        <td>
                            <% if(isSuccess) { %>
                                <span class="status-success">✓ Success</span>
                            <% } else { %>
                                <span class="status-failed">✕ Failed</span>
                            <% } %>
                        </dt>
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
        <% } else { %>
            <div class="empty-state">
                <p>📭 No transactions found</p>
            </div>
        <% } %>
    </div>

    <div class="bottom-buttons">
        <a href="<%= contextPath %>/manager/dashboard.jsp" class="back-btn">← Back to Dashboard</a>
    </div>
</div>

</body>
</html>
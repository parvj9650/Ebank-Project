<%@ page import="java.util.List" %>
<%@ page import="com.ebankdb.model.Transaction" %>
<%@ page import="java.math.BigDecimal" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<html>
<head>
    <meta charset="UTF-8">
    <title>Transaction History - eBankDB</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
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

        .bottom-buttons {
            display: flex;
            justify-content: center;
            margin-top: 20px;
        }

        .status-badge {
            display: inline-block;
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
        }
    </style>
</head>
<body>

<div class="container">
    <div class="page-header">
        <h2>📋 Transaction History</h2>
    </div>
    <br>
    <div class="table-container">
        <%
        List<Transaction> transactions = (List<Transaction>) request.getAttribute("transactions");

        if(transactions != null && !transactions.isEmpty()) {
            // Use BigDecimal for calculations
            BigDecimal credits = BigDecimal.ZERO;
            BigDecimal debits = BigDecimal.ZERO;
            for(Transaction t : transactions) {
                if("Credit".equals(t.getTxnType()) || "Deposit".equals(t.getTxnType())) {
                    credits = credits.add(t.getAmount());
                } else {
                    debits = debits.add(t.getAmount());
                }
            }

            // Create DateTimeFormatter for LocalDateTime
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
                    <th>Account ID</th>
                    <th>Type</th>
                    <th>Amount</th>
                    <th>Date</th>
                    <th>Status</th>
                    <th>Destination Account</th>
                </tr>
            </thead>
            <tbody>
            <%
            for(Transaction t : transactions) {
                String amountClass = ("Credit".equals(t.getTxnType()) || "Deposit".equals(t.getTxnType())) ? "txn-credit" : "txn-debit";
                String txnClass = "";
                if("Deposit".equals(t.getTxnType())) txnClass = "txn-deposit";
                else if("Withdrawal".equals(t.getTxnType())) txnClass = "txn-withdrawal";
                else txnClass = "txn-transfer";

                String formattedDate = t.getTxnDate() != null ? t.getTxnDate().format(formatter) : "-";

                // Get status directly like your original version
                String status = t.getStatus();
            %>
                <tr>
                    <td><span class="account-id">#<%= t.getTxnId() %></span></td>
                    <td>#<%= t.getAccountId() %></dt>
                    <td><span class="txn-type <%= txnClass %>"><%= t.getTxnType() %></span></dt>
                    <td class="<%= amountClass %>">₹ <%= String.format("%,.2f", t.getAmount()) %></dt>
                    <td><%= formattedDate %></dt>
                    <td><span class="status-badge"><%= status %></span></dt>
                    <td><%= (t.getDestinationAcc()==0 ? "Self" : "#"+t.getDestinationAcc()) %></dt>
                </tr>
            <% } %>
            </tbody>
        </table>

        <% } else { %>
            <div class="empty-state">
                <p>📭 No transactions found</p>
            </div>
        <% } %>
    </div>
    <div class="bottom-buttons">
        <a href="<%= request.getContextPath() %>/viewAccounts" class="back-btn">← Back to Accounts</a>
    </div>
</div>

</body>
</html>
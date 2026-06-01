<%@ page import="java.util.List" %>
<%@ page import="com.ebankdb.model.Account" %>
<%@ page import="com.ebankdb.model.Beneficiary" %>
<%@ page import="java.math.BigDecimal" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<html>
<head>
    <meta charset="UTF-8">
    <title>Transfer Money - eBankDB</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        /* Consistent button styling matching the theme */
        .transfer-btn {
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
            width: 100%;
        }

        .transfer-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(20, 184, 166, 0.3);
            background: linear-gradient(135deg, #64748b, #475569);
        }

        /* Back button - Gray/Slate */
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
        }

        /* Remove underline from buttons */
        .transfer-btn, .back-btn {
            text-decoration: none;
        }

        /* Form group styling */
        .form-group {
            margin-bottom: 20px;
        }

        .form-group label {
            display: block;
            margin-bottom: 8px;
            font-weight: 600;
            color: var(--dark);
            font-size: 14px;
        }

        .form-group select, .form-group input {
            width: 100%;
            padding: 12px;
            border: 1px solid #e2e8f0;
            border-radius: 8px;
            font-size: 14px;
            transition: all 0.3s;
            background: white;
        }

        .form-group select:focus, .form-group input:focus {
            outline: none;
            border-color: #14b8a6;
            box-shadow: 0 0 0 3px rgba(20, 184, 166, 0.1);
        }

        /* Message styling */
        .message-success {
            background: #d1fae5;
            color: #065f46;
            padding: 12px 20px;
            border-radius: 8px;
            margin-bottom: 20px;
            border-left: 4px solid #10b981;
        }

        .message-error {
            background: #fee2e2;
            color: #991b1b;
            padding: 12px 20px;
            border-radius: 8px;
            margin-bottom: 20px;
            border-left: 4px solid #ef4444;
        }

        .bottom-buttons {
            display: flex;
            justify-content: center;
            margin-top: 30px;
        }
    </style>
</head>
<body>

<div class="container">
    <div class="page-header">
        <h2>💸 Transfer Money</h2>
    </div>
    <br>
    <div class="table-container" style="max-width: 600px; margin: 0 auto;">
        <%
        String message = (String) request.getAttribute("message");

        if(message != null){
            boolean isError = message.toLowerCase().contains("failed") || message.toLowerCase().contains("insufficient");
        %>
            <div class="<%= isError ? "message-error" : "message-success" %>">
                <%= isError ? "⚠" : "✓" %> <%= message %>
            </div>
        <%
        }
        %>

        <form action="<%= request.getContextPath() %>/transfer" method="post">
            <!-- FROM ACCOUNT -->
            <div class="form-group">
                <label>📤 From Account</label>
                <select name="fromAccount" required>
                    <option value="">-- Select Account --</option>
                    <%
                    List<Account> accounts = (List<Account>) request.getAttribute("accounts");
                    String selectedFrom = (String) request.getAttribute("fromAccount");

                    if(accounts != null){
                        for(Account acc : accounts){
                            String selected = (selectedFrom != null && selectedFrom.equals(String.valueOf(acc.getAccountId()))) ? "selected" : "";
                    %>
                        <option value="<%= acc.getAccountId() %>" <%= selected %>>
                            Account #<%= acc.getAccountId() %> (Balance: ₹ <%= String.format("%,.2f", acc.getBalance()) %>)
                        </option>
                    <%
                        }
                    }
                    %>
                </select>
            </div>

            <!-- TO ACCOUNT -->
            <div class="form-group">
                <label>📥 Transfer To Account ID</label>
                <input type="text" id="toAccount" name="toAccount"
                       value="<%= request.getAttribute("toAccount") != null ? request.getAttribute("toAccount") : "" %>"
                       placeholder="Enter account number" required>
            </div>

            <!-- BENEFICIARY -->
            <div class="form-group">
                <label>👥 Or Select Beneficiary</label>
                <select name="beneficiaryAcc" onchange="fillAccount(this)">
                    <option value="">-- Select Beneficiary --</option>
                    <%
                    List<Beneficiary> beneficiaries = (List<Beneficiary>) request.getAttribute("beneficiaries");

                    if(beneficiaries != null){
                        for(Beneficiary b : beneficiaries){
                    %>
                        <option value="<%= b.getBeneficiaryAccNum() %>">
                            👤 <%= b.getBeneficiaryName() %> (Account #<%= b.getBeneficiaryAccNum() %>)
                        </option>
                    <%
                        }
                    }
                    %>
                </select>
            </div>

            <!-- AMOUNT -->
            <div class="form-group">
                <label>💰 Amount (₹)</label>
                <input type="text" name="amount"
                       value="<%= request.getAttribute("amount") != null ? request.getAttribute("amount") : "" %>"
                       placeholder="Enter amount to transfer" required>
            </div>

            <button type="submit" class="transfer-btn">Transfer Money</button>
        </form>
    </div>

    <div class="bottom-buttons">
        <a href="<%= request.getContextPath() %>/customer/dashboard.jsp" class="back-btn">
            ← Back to Dashboard
        </a>
    </div>
</div>

<script>
    function fillAccount(select) {
        const accountId = select.value;
        document.getElementById("toAccount").value = accountId;
    }
</script>

</body>
</html>
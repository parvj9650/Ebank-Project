<%@ page import="java.math.BigDecimal" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<html>
<head>
    <meta charset="UTF-8">
    <title>Add Funds - eBankDB</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .add-funds-btn {
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

        .add-funds-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(20, 184, 166, 0.3);
            background: linear-gradient(135deg, #64748b, #475569);
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

        .quick-amounts {
            display: flex;
            gap: 10px;
            margin: 15px 0;
            flex-wrap: wrap;
        }
        .quick-amount {
            flex: 1;
            padding: 10px;
            background: #f1f5f9;
            border: 1px solid #e2e8f0;
            border-radius: 8px;
            cursor: pointer;
            text-align: center;
            transition: all 0.3s;
            font-weight: 500;
        }
        .quick-amount:hover {
            background: #14b8a6;
            color: white;
            border-color: #14b8a6;
        }
        .bottom-buttons {
            display: flex;
            justify-content: center;
            margin-top: 20px;
        }
    </style>
    <script>
        function setAmount(amount) {
            document.getElementById('amount').value = amount;
        }
    </script>
</head>
<body>

<div class="container">
    <div class="page-header">
        <h2>💰 Add Funds</h2>
    </div>
    <br>
    <div class="table-container" style="max-width: 600px; margin: 0 auto;">
        <!-- Error message at the top of the card -->
        <% if(request.getAttribute("error") != null){ %>
            <div class="alert-error" style="margin-bottom: 20px;">
                ⚠ <%= request.getAttribute("error") %>
            </div>
        <% } %>

        <form action="addFunds" method="post">
            <input type="hidden" name="accountId" value="<%= request.getAttribute("accountId") %>">

            <div class="form-group">
                <label>Amount (₹)</label>
                <input type="text" id="amount" name="amount" placeholder="Enter amount" required>
            </div>

            <div class="quick-amounts">
                <div class="quick-amount" onclick="setAmount(500)">₹500</div>
                <div class="quick-amount" onclick="setAmount(1000)">₹1,000</div>
                <div class="quick-amount" onclick="setAmount(5000)">₹5,000</div>
                <div class="quick-amount" onclick="setAmount(10000)">₹10,000</div>
            </div>

            <button type="submit" class="add-funds-btn">Add Funds</button>
        </form>
    </div>

    <div class="bottom-buttons">
        <a href="viewAccounts" class="back-btn">← Back to Accounts</a>
    </div>
</div>

</body>
</html>
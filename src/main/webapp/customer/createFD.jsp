<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.math.BigDecimal" %>
<%@ page import="java.time.LocalDate" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="java.time.temporal.ChronoUnit" %>

<html>
<head>
    <meta charset="UTF-8">
    <title>Create Fixed Deposit - eBankDB</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .create-fd-btn {
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

        .create-fd-btn:hover {
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

        .interest-info {
            background: linear-gradient(135deg, #d1fae5, #a7f3d0);
            padding: 15px;
            border-radius: 12px;
            margin-bottom: 20px;
            text-align: center;
        }

        .interest-rate {
            font-size: 28px;
            font-weight: bold;
            color: #065f46;
        }

        .interest-slabs {
            background: #f1f5f9;
            padding: 12px;
            border-radius: 8px;
            margin-top: 15px;
            font-size: 12px;
        }

        .interest-slabs table {
            width: 100%;
            font-size: 12px;
        }

        .interest-slabs td {
            padding: 5px;
        }

        .penalty-note {
            background: #fed7aa;
            padding: 12px;
            border-radius: 8px;
            margin-top: 20px;
            font-size: 13px;
            color: #92400e;
            text-align: center;
        }

        .bottom-buttons {
            display: flex;
            justify-content: center;
            margin-top: 20px;
        }

        .maturity-preview {
            background: #e0f2fe;
            padding: 12px;
            border-radius: 8px;
            margin: 15px 0;
            text-align: center;
            font-weight: 500;
            color: #0369a1;
        }
    </style>
    <script>
        function calculateMaturity() {
            let amount = document.getElementById('amount').value;
            let maturityDate = document.getElementById('maturity').value;

            if(amount && amount > 0 && maturityDate) {
                let today = new Date();
                let maturity = new Date(maturityDate);

                if(maturity > today) {
                    // Calculate days difference
                    let diffTime = Math.abs(maturity - today);
                    let diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24));
                    let months = diffDays / 30;

                    let interestRate = 5.0;
                    if(months <= 6) interestRate = 5.0;
                    else if(months <= 12) interestRate = 6.0;
                    else if(months <= 24) interestRate = 7.0;
                    else if(months <= 36) interestRate = 7.5;
                    else interestRate = 8.0;

                    let years = diffDays / 365;
                    let interestAmount = parseFloat(amount) * (interestRate / 100) * years;
                    let maturityAmount = parseFloat(amount) + interestAmount;

                    document.getElementById('maturity-preview').innerHTML =
                        '📈 Estimated Maturity Amount: <strong>₹ ' + maturityAmount.toFixed(2) + '</strong><br>' +
                        '<small>Interest Rate: ' + interestRate + '% p.a. | Tenure: ' + Math.round(months) + ' months</small>';
                    document.getElementById('maturity-preview').style.display = 'block';
                } else {
                    document.getElementById('maturity-preview').style.display = 'none';
                }
            } else {
                document.getElementById('maturity-preview').style.display = 'none';
            }
        }

        function setMinDate() {
            let today = new Date();
            let dd = String(today.getDate()).padStart(2, '0');
            let mm = String(today.getMonth() + 1).padStart(2, '0');
            let yyyy = today.getFullYear();
            let minDate = yyyy + '-' + mm + '-' + dd;
            document.getElementById('maturity').min = minDate;
        }

        window.onload = setMinDate;
    </script>
</head>
<body>

<div class="container">
    <div class="page-header">
        <h2>📈 Create Fixed Deposit</h2>
    </div>
    <br>
    <div class="table-container" style="max-width: 600px; margin: 0 auto;">
        <%
        String error = (String) request.getAttribute("error");
        if(error != null){
        %>
            <div class="alert-error" style="margin-bottom: 20px;">
                ⚠ <%= error %>
            </div>
        <%
        }
        %>

        <div class="interest-info">
            <div>💰 Interest Rates (p.a.)</div>
            <div class="interest-rate">Up to 8%</div>
            <div class="interest-slabs">
                <table>
                    <tr><td><strong>Tenure</strong></td><td><strong>Interest Rate</strong></td></tr>
                    <tr><td>Up to 6 months</td><td>5.0%</td></tr>
                    <tr><td>6 - 12 months</td><td>6.0%</td></tr>
                    <tr><td>1 - 2 years</td><td>7.0%</td></tr>
                    <tr><td>2 - 3 years</td><td>7.5%</td></tr>
                    <tr><td>3+ years</td><td>8.0%</td></tr>
                </table>
            </div>
        </div>

        <%
        int accountId = Integer.parseInt(request.getParameter("accountId"));
        %>

        <form action="${pageContext.request.contextPath}/createFD" method="post" onsubmit="return validateForm()">
            <input type="hidden" name="accountId" value="<%= accountId %>">

            <div class="form-group">
                <label>Deposit Amount (₹)</label>
                <input type="number" id="amount" name="amount" onkeyup="calculateMaturity()"
                       placeholder="Minimum ₹1,000" step="500" min="1000" required>
            </div>
            <br>
            <div class="form-group">
                <label>Maturity Date</label>
                <input type="date" id="maturity" name="maturity" onchange="calculateMaturity()" required>
            </div>

            <div id="maturity-preview" class="maturity-preview" style="display: none;"></div>
            <br>
            <button type="submit" class="create-fd-btn">Create Fixed Deposit</button>
        </form>

        <div class="penalty-note">
            ⚠ <strong>Important:</strong> Early withdrawal before maturity will incur a penalty of 1% on the interest earned.
        </div>
    </div>

    <div class="bottom-buttons">
        <a href="<%= request.getContextPath() %>/viewAccounts" class="back-btn">← Back to Accounts</a>
    </div>
</div>

<script>
    function validateForm() {
        let amount = document.getElementById('amount').value;
        let maturity = document.getElementById('maturity').value;

        if(amount < 1000) {
            alert('Minimum deposit amount is ₹1,000');
            return false;
        }

        if(!maturity) {
            alert('Please select a maturity date');
            return false;
        }

        let today = new Date();
        let selectedDate = new Date(maturity);
        today.setHours(0, 0, 0, 0);

        if(selectedDate <= today) {
            alert('Maturity date must be in the future');
            return false;
        }

        return true;
    }
</script>

</body>
</html>
<%@ page import="java.util.List" %>
<%@ page import="com.ebankdb.model.FixedDeposit" %>
<%@ page import="java.math.BigDecimal" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<html>
<head>
    <meta charset="UTF-8">
    <title>Fixed Deposits - eBankDB</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        /* Consistent button styling */
        .create-btn {
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

        .create-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(20, 184, 166, 0.3);
            background: linear-gradient(135deg, #0d9488, #0f766e);
        }

        /* Back button - Teal matching theme */
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

        /* Break FD Button - Red/Pink matching cancel button */
        .break-fd-btn {
            background: linear-gradient(135deg, #f43f5e, #e11d48);
            color: white;
            padding: 8px 16px;
            border-radius: 8px;
            text-decoration: none;
            font-weight: 600;
            display: inline-flex;
            align-items: center;
            gap: 6px;
            transition: all 0.3s;
            font-size: 12px;
            border: none;
            cursor: pointer;
        }

        .break-fd-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(244, 63, 94, 0.4);
            background: linear-gradient(135deg, #475569, #334155);
        }

        /* Remove underline from all buttons */
        .create-btn, .back-btn, .break-fd-btn {
            text-decoration: none;
        }

        /* Consistent status badge sizes */
        .status-active, .status-closed {
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

        .status-closed {
            background: #fee2e2;
            color: #991b1b;
        }

        /* Bottom buttons container - centers the button */
        .bottom-buttons {
            display: flex;
            justify-content: center;
            align-items: center;
            margin-top: 30px;
        }
    </style>
</head>
<body>

<div class="container">
    <div class="page-header">
        <h2>📈 Your Fixed Deposits</h2>
    </div>
    <br>
    <%
    String error = (String) request.getAttribute("error");
    if(error != null){
    %>
        <div class="alert-error">
            ⚠ <%= error %>
        </div>
    <%
    }
    %>

    <div class="table-container">
        <%
        List<FixedDeposit> fds = (List<FixedDeposit>) request.getAttribute("fds");

        if(fds != null && !fds.isEmpty()){
            // Calculate summary
            BigDecimal totalInvested = BigDecimal.ZERO;
            BigDecimal totalMaturity = BigDecimal.ZERO;
            int activeCount = 0;
            for(FixedDeposit fd : fds) {
                totalInvested = totalInvested.add(fd.getDepositAmt());
                totalMaturity = totalMaturity.add(fd.getMaturityAmt());
                if("Active".equals(fd.getStatus())) {
                    activeCount++;
                }
            }
        %>

        <!-- Summary Bar -->
        <div class="accounts-summary">
            <div class="summary-item">
                <span class="summary-label">💰 Total Invested:</span>
                <span class="summary-value">₹ <%= String.format("%,.2f", totalInvested) %></span>
            </div>
            <div class="summary-item">
                <span class="summary-label">✅ Active FDs:</span>
                <span class="summary-value"><%= activeCount %></span>
            </div>
        </div>
        <br>
        <table>
            <thead>
                <tr>
                    <th>FD ID</th>
                    <th>Account</th>
                    <th>Amount</th>
                    <th>Interest</th>
                    <th>Start Date</th>
                    <th>Maturity Date</th>
                    <th>Maturity Amount</th>
                    <th>Status</th>
                    <th>Action</th>
                </tr>
            </thead>
            <tbody>
            <%
            for(FixedDeposit fd : fds){
            %>
                <tr>
                    <td><span class="account-id">#<%= fd.getFdId() %></span></td>
                    <td>#<%= fd.getAccountId() %></td>
                    <td class="balance-positive">₹ <%= String.format("%,.2f", fd.getDepositAmt()) %></td>
                    <td><span class="status-active"><%= fd.getInterestRate() %>%</span></td>
                    <td><%= fd.getStartDate() %></td>
                    <td><%= fd.getMaturityDate() %></td>
                    <td class="balance-positive">₹ <%= String.format("%,.2f", fd.getMaturityAmt()) %></td>
                    <td>
                        <% if("Active".equals(fd.getStatus())) { %>
                            <span class="status-active">● Active</span>
                        <% } else { %>
                            <span class="status-closed">✕ Closed</span>
                        <% } %>
                    </td>
                    <td class="account-actions">
                        <%
                        if(fd.getStatus().equals("Active")){
                        %>
                            <a href="${pageContext.request.contextPath}/breakFD?fdId=<%= fd.getFdId() %>"
                               class="break-fd-btn"
                               onclick="return confirm('Are you sure you want to break this FD? Early withdrawal may incur penalty.')">
                                Break FD
                            </a>
                        <%
                        } else {
                            out.print("<span style='color: #94a3b8;'>-</span>");
                        }
                        %>
                    </td>
                </tr>
            <%
            }
            %>
            </tbody>
        </table>

        <% } else { %>
            <div class="empty-state">
                <p>📭 No Fixed Deposits found.</p>
                <a href="accounts.jsp" class="btn btn-primary">Create an FD from your account →</a>
            </div>
        <% } %>
    </div>

    <div class="bottom-buttons">
        <a href="customer/dashboard.jsp" class="back-btn">
            ← Back to Dashboard
        </a>
    </div>
</div>

</body>
</html>
<%@ page import="java.util.List" %>
<%@ page import="com.ebankdb.model.Branch" %>
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Create Account - eBankDB</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .form-container {
            max-width: 500px;
            margin: 0 auto;
            padding: 40px 20px;
        }

        .form-box {
            background: white;
            border-radius: var(--border-radius);
            padding: 30px;
            box-shadow: var(--shadow);
        }

        .page-header {
            text-align: center;
            margin-bottom: 30px;
        }

        .page-header h2 {
            color: var(--dark);
            font-size: 28px;
        }

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

        .form-group select,
        .form-group input {
            width: 100%;
            padding: 12px;
            border: 1.5px solid #e2e8f0;
            border-radius: 8px;
            font-size: 14px;
            transition: all 0.3s;
        }

        .form-group select:focus,
        .form-group input:focus {
            outline: none;
            border-color: #14b8a6;
            box-shadow: 0 0 0 3px rgba(20, 184, 166, 0.1);
        }

        .create-account-btn {
            background: linear-gradient(135deg, #14b8a6, #0d9488);
            color: white;
            padding: 12px 28px;
            border-radius: 10px;
            border: none;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
            font-size: 16px;
            width: 100%;
        }

        .create-account-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(20, 184, 166, 0.3);
            background: linear-gradient(135deg, #475569, #334155);
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
            font-size: 14px;
            margin-top: 20px;
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
            margin-top: 20px;
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

        .info-note {
            background: #dbeafe;
            color: #1e40af;
            padding: 12px 20px;
            border-radius: 8px;
            margin-bottom: 20px;
            border-left: 4px solid #3b82f6;
            display: flex;
            align-items: center;
            gap: 10px;
            font-size: 13px;
        }
    </style>
</head>
<body>

<div class="form-container">
    <div class="page-header">
        <h2>🏦 Create Account</h2>
    </div>

    <div class="form-box">
        <%
        String error = (String) request.getAttribute("error");
        if(error != null){
        %>
            <div class="error-message">
                <span>⚠</span> <%= error %>
            </div>
        <%
        }
        %>

        <div class="info-note">
            <span>ℹ️</span>
            <span>Creating account for Customer ID: <strong>#<%= request.getAttribute("customerId") %></strong></span>
        </div>

        <form action="<%=request.getContextPath()%>/employeeCreateAccount" method="post">
            <input type="hidden" name="customerId" value="<%=request.getAttribute("customerId")%>">

            <div class="form-group">
                <label>🏢 Select Branch</label>
                <select name="branchId">
                    <%
                    List<Branch> branches = (List<Branch>) request.getAttribute("branches");
                    if(branches != null){
                        for(Branch b : branches){
                    %>
                        <option value="<%=b.getBranchId()%>">
                            <%= b.getBranchName() %> - <%= b.getIfsc() %>
                        </option>
                    <%
                        }
                    }
                    %>
                </select>
            </div>
            <br>
            <div class="form-group">
                <label>💰 Account Type</label>
                <select name="accountType">
                    <option value="Savings">💰 Savings Account</option>
                    <option value="Current">💼 Current Account</option>
                </select>
            </div>
            <br>
            <div class="form-group">
                <label>💵 Initial Deposit (₹)</label>
                <input type="number" name="balance" placeholder="Minimum ₹500" required>
            </div>

            <button type="submit" class="create-account-btn">Create Account</button>
        </form>
    </div>

    <div class="bottom-buttons">
        <a href="employee/dashboard.jsp" class="back-btn">← Back to Dashboard</a>
    </div>
</div>

</body>
</html>
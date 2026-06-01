<%@ page import="com.ebankdb.model.User" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.ebankdb.model.Manager" %>
<%
User user = (User) session.getAttribute("user");
if(user == null || !"Manager".equals(user.getRole())) {
    response.sendRedirect(request.getContextPath() + "/login.jsp");
    return;
}
%>

<%
Manager manager = (Manager) session.getAttribute("manager");
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Manager Dashboard - eBankDB</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .dashboard-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 25px;
            margin-top: 30px;
        }

        .dashboard-card {
            background: white;
            border-radius: var(--border-radius);
            padding: 25px;
            text-align: center;
            transition: all 0.3s;
            box-shadow: var(--shadow);
            text-decoration: none;
            display: block;
        }

        .dashboard-card:hover {
            transform: translateY(-5px);
            box-shadow: var(--shadow-lg);
        }

        .card-icon {
            font-size: 48px;
            margin-bottom: 15px;
        }

        .card-title {
            font-size: 18px;
            font-weight: 600;
            color: var(--dark);
            margin-bottom: 8px;
        }

        .card-desc {
            font-size: 13px;
            color: var(--gray);
        }

        .welcome-header {
            background: white;
            padding: 40px;
            border-radius: var(--border-radius);
            margin-bottom: 30px;
            text-align: center;
            box-shadow: var(--shadow);
        }

        .welcome-header h2 {
            color: black;
            margin-bottom: 10px;
            font-size: 28px;
        }

        .welcome-header p {
            color: var(--gray);
        }

        /* Edit Profile button - Teal */
        .edit-profile-btn {
            background: linear-gradient(135deg, #14b8a6, #0d9488);
            color: white;
            padding: 8px 20px;
            border-radius: 8px;
            text-decoration: none;
            font-weight: 600;
            display: inline-flex;
            align-items: center;
            gap: 6px;
            transition: all 0.3s;
            font-size: 13px;
            border: none;
            cursor: pointer;
        }

        .edit-profile-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(20, 184, 166, 0.3);
            background: linear-gradient(135deg, #0d9488, #0f766e);
            text-decoration: none;
        }

        /* Logout button - Red/Pink */
        .logout-btn-custom {
            background: linear-gradient(135deg, #f43f5e, #e11d48);
            color: white;
            padding: 8px 20px;
            border-radius: 8px;
            text-decoration: none;
            font-weight: 600;
            display: inline-flex;
            align-items: center;
            gap: 6px;
            transition: all 0.3s;
            font-size: 13px;
            border: none;
            cursor: pointer;
        }

        .logout-btn-custom:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(244, 63, 94, 0.4);
            background: linear-gradient(135deg, #e11d48, #be123c);
            text-decoration: none;
        }
    </style>
</head>
<body>

<%
if(manager == null){
    response.sendRedirect(request.getContextPath() + "/login.jsp");
    return;
}
%>

<div class="dashboard-header">
    <div class="header-content">
        <h1>🏦 eBankDB</h1>
        <div class="user-info">
            <a href="${pageContext.request.contextPath}/editManagerProfile" class="edit-profile-btn">✏️ Edit Profile</a>
            <a href="${pageContext.request.contextPath}/logout" class="logout-btn-custom">🚪 Logout</a>
        </div>
    </div>
</div>

<div class="container">
    <div class="welcome-header">
        <h2>Welcome, <%= manager.getName() %>! 👋</h2>
        <p>Manage accounts, employees, and monitor all banking activities</p>
    </div>

    <div class="dashboard-grid">
        <a href="${pageContext.request.contextPath}/managerCustomerView" class="dashboard-card">
            <div class="card-icon">👥</div>
            <div class="card-title">View Customers</div>
            <div class="card-desc">View all customer details and information</div>
        </a>

        <a href="${pageContext.request.contextPath}/managerEmployeeView" class="dashboard-card">
            <div class="card-icon">👔</div>
            <div class="card-title">View Employees</div>
            <div class="card-desc">View all employee details</div>
        </a>

        <a href="${pageContext.request.contextPath}/managerAccounts" class="dashboard-card">
            <div class="card-icon">⚙️</div>
            <div class="card-title">Manage Accounts</div>
            <div class="card-desc">Freeze or activate customer accounts</div>
        </a>

        <a href="${pageContext.request.contextPath}/viewAllTransactions" class="dashboard-card">
            <div class="card-icon">📋</div>
            <div class="card-title">View Transactions</div>
            <div class="card-desc">Monitor all customer transactions</div>
        </a>

        <a href="${pageContext.request.contextPath}/transactionSummary" class="dashboard-card">
            <div class="card-icon">📊</div>
            <div class="card-title">Transaction Summary</div>
            <div class="card-desc">View transaction reports and analytics</div>
        </a>

        <a href="${pageContext.request.contextPath}/viewAuditLogs" class="dashboard-card">
            <div class="card-icon">📜</div>
            <div class="card-title">View Audit Logs</div>
            <div class="card-desc">Track all system activities</div>
        </a>
    </div>
</div>

</body>
</html>
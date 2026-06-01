<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.ebankdb.model.Customer" %>
<html>
<head>
    <meta charset="UTF-8">
    <title>Customer Dashboard - eBankDB</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .dashboard-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
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

        /* Edit Profile button - Teal like back button */
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
            background: linear-gradient(135deg, #64748b, #475569);
            text-decoration: none;
        }

        /* Logout button - Red/Pink like break FD button */
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
            background: linear-gradient(135deg, #64748b, #475569);
            text-decoration: none;
        }
    </style>
</head>
<body>

<%
Customer customer = (Customer) session.getAttribute("customer");

if(customer == null){
    response.sendRedirect("../login.jsp");
    return;
}
%>

<div class="dashboard-header">
    <div class="header-content">
        <h1>🏦 eBankDB</h1>
        <div class="user-info">
            <a href="${pageContext.request.contextPath}/editCustomerProfile" class="edit-profile-btn">Edit Profile</a>
            <a href="${pageContext.request.contextPath}/logout" class="logout-btn-custom">Logout</a>
        </div>
    </div>
</div>

<div class="container">
    <div class="welcome-header">
        <h2>Welcome, <%= customer.getName() %>! 👋</h2>
        <p>Manage your finances, track transactions, and grow your savings</p>
    </div>

    <div class="dashboard-grid">
        <a href="${pageContext.request.contextPath}/viewAccounts" class="dashboard-card">
            <div class="card-icon">🏦</div>
            <div class="card-title">View Accounts</div>
            <div class="card-desc">Check your account balances and details</div>
        </a>

        <a href="${pageContext.request.contextPath}/transfer" class="dashboard-card">
            <div class="card-icon">💸</div>
            <div class="card-title">Transfer Money</div>
            <div class="card-desc">Send money to other accounts</div>
        </a>

        <a href="${pageContext.request.contextPath}/viewBeneficiaries" class="dashboard-card">
            <div class="card-icon">👥</div>
            <div class="card-title">Beneficiaries</div>
            <div class="card-desc">Manage your saved beneficiaries</div>
        </a>

        <a href="${pageContext.request.contextPath}/viewFDs" class="dashboard-card">
            <div class="card-icon">📈</div>
            <div class="card-title">Fixed Deposits</div>
            <div class="card-desc">View and manage your FDs</div>
        </a>
    </div>
</div>

</body>
</html>
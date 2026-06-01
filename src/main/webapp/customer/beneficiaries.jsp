<%@ page import="java.util.List" %>
<%@ page import="com.ebankdb.model.Beneficiary" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<html>
<head>
    <title>Your Beneficiaries - eBankDB</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        /* Consistent button styling */
        .create-btn, .dashboard-back-btn {
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

        .create-btn:hover, .dashboard-back-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(37, 99, 235, 0.3);
            background: linear-gradient(135deg, #64748b, #475569);
        }

        /* Improved Delete Button */
        .delete-beneficiary-btn {
            background: linear-gradient(135deg, #f43f5e, #e11d48);
            color: white;
            padding: 8px 20px;
            border-radius: 8px;
            text-decoration: none;
            font-weight: 600;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            transition: all 0.3s;
            font-size: 13px;
            border: none;
            cursor: pointer;
        }

        .delete-beneficiary-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(239, 68, 68, 0.4);
            background: linear-gradient(135deg, #64748b, #475569);
        }

        /* Remove underline from all buttons */
        .create-btn, .dashboard-back-btn, .delete-beneficiary-btn, .btn-primary {
            text-decoration: none;
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
        }
    </style>
</head>
<body>

<div class="container">
    <div class="page-header">
        <h2>👥 Your Beneficiaries</h2>
        <a href="customer/addBeneficiary.jsp" class="create-btn">➕ Add Beneficiary</a>
    </div>
    <br>
    <div class="table-container">
        <%
        List<Beneficiary> list = (List<Beneficiary>) request.getAttribute("beneficiaries");

        if(list != null && !list.isEmpty()){
        %>
        <table>
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Name</th>
                    <th>Account Number</th>
                    <th>Action</th>
                </tr>
            </thead>
            <tbody>
            <%
            for(Beneficiary b : list){
            %>
                <tr>
                    <td><span class="account-id">#<%= b.getBeneficiaryId() %></span></td>
                    <td><strong><%= b.getBeneficiaryName() %></strong></td>
                    <td>#<%= b.getBeneficiaryAccNum() %></td>
                    <td>
                        <a href="<%= request.getContextPath() %>/deleteBeneficiary?id=<%= b.getBeneficiaryId() %>"
                           class="delete-beneficiary-btn"
                           onclick="return confirm('Are you sure you want to delete <%= b.getBeneficiaryName() %> from beneficiaries?')">
                            Delete
                        </a>
                    </td>
                </tr>
            <%
            }
            %>
            </tbody>
        </table>

        <% } else { %>
            <div class="empty-state">
                <p> No beneficiaries added yet.</p>
                <a href="customer/addBeneficiary.jsp" class="btn btn-primary">Add your first beneficiary →</a>
            </div>
        <% } %>
    </div>

    <div class="bottom-buttons">
        <a href="customer/dashboard.jsp" class="dashboard-back-btn">
            ← Back to Dashboard
        </a>
    </div>
</div>

</body>
</html>
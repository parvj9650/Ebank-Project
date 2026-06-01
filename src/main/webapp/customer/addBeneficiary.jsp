<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<html>
<head>
    <meta charset="UTF-8">
    <title>Add Beneficiary - eBankDB</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        /* Consistent button styling matching beneficiaries page */
        .btn-primary {
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

        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(20, 184, 166, 0.3);
            background: linear-gradient(135deg, #475569, #334155);
        }

        /* Cancel button - Gray/Slate matching the back button style */
        .btn-cancel {
            background: linear-gradient(135deg, #f43f5e, #e11d48);
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

        .btn-cancel:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(100, 116, 139, 0.3);
            background: linear-gradient(135deg, #475569, #334155);
        }

        /* Remove underline from buttons */
        .btn-primary, .btn-cancel {
            text-decoration: none;
        }

        /* Form group spacing */
        .form-group {
            margin-bottom: 20px;
        }

        .form-group label {
            display: block;
            margin-bottom: 8px;
            font-weight: 500;
            color: var(--dark);
        }

        .form-group input {
            width: 100%;
            padding: 12px;
            border: 1px solid #e2e8f0;
            border-radius: 8px;
            font-size: 14px;
            transition: all 0.3s;
        }

        .form-group input:focus {
            outline: none;
            border-color: #14b8a6;
            box-shadow: 0 0 0 3px rgba(20, 184, 166, 0.1);
        }
    </style>
</head>
<body>

<div class="container">
    <div class="page-header">
        <h2>👤 Add Beneficiary</h2>
    </div>
    <br>
    <div class="table-container" style="max-width: 600px; margin: 0 auto;">
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

        <form action="<%= request.getContextPath() %>/addBeneficiary" method="post">
            <div class="form-group">
                <label>Beneficiary Name</label>
                <input type="text" name="name" placeholder="Enter full name" required>
            </div>

            <div class="form-group">
                <label>Account Number</label>
                <input type="text" name="accountNumber" placeholder="Enter account number" required>
            </div>

            <div style="display: flex; gap: 15px; margin-top: 25px;">
                <button type="submit" class="btn-primary">➕ Add Beneficiary</button>
                <a href="<%= request.getContextPath() %>/viewBeneficiaries" class="btn-cancel">← Cancel</a>
            </div>
        </form>
    </div>
</div>

</body>
</html>
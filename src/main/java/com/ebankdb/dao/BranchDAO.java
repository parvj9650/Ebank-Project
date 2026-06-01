package com.ebankdb.dao;

import com.ebankdb.config.DBConnection;
import com.ebankdb.model.Branch;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class BranchDAO {

    public List<Branch> getAllBranches(){
        List<Branch> list = new ArrayList<>();
        try{
            Connection conn = DBConnection.getConnection();

            String sql = "SELECT * FROM Branch";
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();

            while(rs.next()){
                Branch b = new Branch();
                b.setBranchId(rs.getInt("branch_id"));
                b.setBranchName(rs.getString("branch_name"));
                b.setAddress(rs.getString("address"));
                b.setIfsc(rs.getString("IFSC"));
                list.add(b);
            }

        }catch(Exception e){
            e.printStackTrace();
        }

        return list;
    }
}
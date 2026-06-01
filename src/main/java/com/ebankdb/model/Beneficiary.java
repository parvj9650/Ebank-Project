package com.ebankdb.model;

import java.time.LocalDate;

public class Beneficiary {

    private int beneficiaryId;
    private int customerId;
    private String beneficiaryName;
    private String beneficiaryAccNum;
    private LocalDate date;

    public Beneficiary() {}

    public int getBeneficiaryId() {
        return beneficiaryId;
    }

    public void setBeneficiaryId(int beneficiaryId) {
        this.beneficiaryId = beneficiaryId;
    }

    public int getCustomerId() {
        return customerId;
    }

    public void setCustomerId(int customerId) {
        this.customerId = customerId;
    }

    public String getBeneficiaryName() {
        return beneficiaryName;
    }

    public void setBeneficiaryName(String beneficiaryName) {
        this.beneficiaryName = beneficiaryName;
    }

    public String getBeneficiaryAccNum() {
        return beneficiaryAccNum;
    }

    public void setBeneficiaryAccNum(String beneficiaryAccNum) {
        this.beneficiaryAccNum = beneficiaryAccNum;
    }

    public LocalDate getDate() {
        return date;
    }

    public void setDate(LocalDate date) {
        this.date = date;
    }
}
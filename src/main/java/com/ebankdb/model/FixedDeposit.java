package com.ebankdb.model;

import java.math.BigDecimal;
import java.time.LocalDate;

public class FixedDeposit {

    private int fdId;
    private int customerId;
    private int accountId;
    private BigDecimal depositAmt;
    private double interestRate;
    private LocalDate startDate;
    private LocalDate maturityDate;
    private String status;

    private BigDecimal maturityAmt;

    public FixedDeposit() {}

    public int getFdId() {
        return fdId;
    }

    public void setFdId(int fdId) {
        this.fdId = fdId;
    }

    public int getCustomerId() {
        return customerId;
    }

    public void setCustomerId(int customerId) {
        this.customerId = customerId;
    }

    public int getAccountId() {
        return accountId;
    }

    public void setAccountId(int accountId) {
        this.accountId = accountId;
    }

    public BigDecimal getDepositAmt() {
        return depositAmt;
    }

    public void setDepositAmt(BigDecimal depositAmt) {
        this.depositAmt = depositAmt;
    }

    public double getInterestRate() {
        return interestRate;
    }

    public void setInterestRate(double interestRate) {
        this.interestRate = interestRate;
    }

    public LocalDate getStartDate() {
        return startDate;
    }

    public void setStartDate(LocalDate startDate) {
        this.startDate = startDate;
    }

    public LocalDate getMaturityDate() {
        return maturityDate;
    }

    public void setMaturityDate(LocalDate maturityDate) {
        this.maturityDate = maturityDate;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public void setMaturityAmt(BigDecimal maturityAmt) {
        this.maturityAmt = maturityAmt;
    }

    public BigDecimal getMaturityAmt() {
        return maturityAmt;
    }
}
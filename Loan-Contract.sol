pragma solidity ^0.4.2;
/* define all variables used*/

contract Loan {
    address public borrower;
    address public lender;
    uint public amountBorrowed;
    uint public amountRepaid;
    uint public InterestRateInPercent;
    uint public Interest;
	  uint public RepaymentDay1;
    uint public RepaymentDay2;
    uint public RepaymentDay3;
    uint public repayment1;
    uint public repayment2;
    uint public repayment3;
    event FundTransfer(address backer, uint amount);

/*  at initialization, define borrower, lender, tenor and interest rate*/
    function Loan(address BorrowerAddress, address LenderAddress, uint LoanTenor, uint InterestRateInPercent) {
        borrower = BorrowerAddress;
    		lender = LenderAddress;
    		Interest = InterestRateInPercent;
    		RepaymentDay1 = now + LoanTenor/3 * 1 minutes;
    		RepaymentDay2 = now + LoanTenor/3*2 * 1 minutes;
    		RepaymentDay3 = now + LoanTenor * 1 minutes ;
    }

/* this function would be triggered whenever a transfer to the contract is made. separately define the amount borrowed and amount repaid for lender, borrower respectively*/
    function () {
      uint amount = msg.value;
  		if (borrower == msg.sender){
        amountRepaid = amount;
      }
  		if (lender == msg.sender){
        amountBorrowed = amount;
      }
      FundTransfer(msg.sender, amount);
    }

/* borrower can only withdraw the amount borrowed, which is defined by amount sent to contract by lender*/
    function BorrowerWithdrawl() {
        if (borrower == msg.sender) {
            if (borrower.send(amountBorrowed)) {
              FundTransfer(borrower, amountBorrowed);
            }
        }
    }
/* lender can only withdraw the amount repaid, which is defined by amount sent to contract by borrower*/
    function LenderWithdrawal() {
        if (lender == msg.sender) {
            if (lender.send(amountRepaid)) {
              FundTransfer(lender, amountRepaid);
            }
        }
    }
/* execute function to calculate interest and repayment amount*/
	function CheckRepaymentAmount(){
  	repayment1 = (amountBorrowed * Interest)/100;
  	repayment2 = (amountBorrowed * Interest)/100;
  	repayment3 = amountBorrowed + (amountBorrowed * Interest)/100;
	}
}

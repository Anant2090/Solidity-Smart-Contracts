// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
contract banking_industry
{
    mapping(address=>uint) private balance;
    mapping(address=>bool) private Is_User;
    address owner;



    function Create_Account() public 

    {
        require(Is_User[msg.sender]!=true,"you have alredy an one account");
        Is_User[msg.sender]=true;
    }

    function Deposit_funds() public payable
    {
        require(Is_User[msg.sender]==true,"You do not hold account in our Digital Bank, So go and Create an account for your self");
        require(msg.value>0," You are Joking With us, next time you will do this joke i will block your account immediately");
        balance[msg.sender]+=msg.value;
    }
    
    function transfer_funds(address _user,uint value) public payable 
    {
        require(Is_User[msg.sender]==true,"You Do not Hold Any Account in Our Bank so How you Can transfer the Ammount ");
        require(balance[msg.sender]>0,"Your Account Does not Have Any Balance So How you can Transfer the ammount");
        require(balance[msg.sender]>=value,"Insufficient Funds");
        payable (_user).transfer(value);
        balance[msg.sender]-=value;
    }

    function Get_Balance() view public  returns(uint)
    {
        require(Is_User[msg.sender]==true,"You Do not Hold Any Account in Our Bank ");
        return balance[msg.sender];

    }

    function Withdraw_Funds(uint value ) public 
    {
        require(Is_User[msg.sender]==true,"You Do not Hold Any Account in Our Bank ");
        require(balance[msg.sender]>=value,"Insufficient Balance");
        payable (msg.sender).transfer(value);

        balance[msg.sender]-=value;
    }


    function Destroy_Account() public 
    {
        require(Is_User[msg.sender]==true,"You Do not Hold Any Account in Our Bank");
        require(balance[msg.sender]==0,"Your Account Has funds Go And Withdraw Funds First");
        Is_User[msg.sender]=false;

    }

}   
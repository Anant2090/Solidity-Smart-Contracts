// SPDX-License-Identifier: MIT
pragma solidity>0.5.0 <=0.9.0;

contract lotery
{
    address  public manager;
    address payable[] public participants;

    constructor()
    {
        manager=msg.sender;
    }

    receive() external payable 
    {
        participants.push(payable (msg.sender));

    }

    function getbalance() view public returns(uint)
    {
        require(msg.sender==manager);
        return address(this).balance;

    }
    function random() public view returns(uint)
    {
        return uint(keccak256(abi.encodePacked(blockhash(block.number - 1))));
    }

    function selectWinner()   public 
    {
        require(msg.sender==manager);
        uint r=random();
        address payable winner;
        uint index= r%participants.length;
        winner=participants[index];
        uint prize=getbalance();
        require(prize>0);
        winner.transfer(prize);
        participants=new address payable [](0);


    }
}

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
contract DAO
{
    struct Proposal
    {
        uint id;
        string description;
        uint amount;
        address payable receipient;
        uint votes;
        uint end;//end means when voting time of the proposal will end
        bool isExecuted;//


    }
    mapping (address=>bool)private is_invester;
    mapping(address=>uint )public numOfshares;
    mapping (address=>mapping (uint=>bool)) public isVoted;
    // mapping(address=>mapping(address=>bool)) public withdraw_status;
    address[] public investor_list;

    mapping (uint=>Proposal) public proposals;

    uint public totalShares;
    uint public available_funds;
    uint public contributionTimeEnd;//
    uint public nextProposalId;
    uint public voteTime;
    uint public quorum;//minimum no of votes
    address public manager;

    constructor(uint _contributionTimeEnd,uint _voteTime,uint _quorum)
    {
        require(_quorum>0 &&_quorum<=100,"not valid values");
        contributionTimeEnd=block.timestamp+ _contributionTimeEnd;
        voteTime=_voteTime;
        quorum=_quorum;
        manager=msg.sender;

    }

    modifier onlyInvester() 
    {
        require(is_invester[msg.sender]==true,"you not an investor");
        _;
    }
    modifier onlyManager()
    {
        require(manager==msg.sender,"your are not an manager");
        _;
    }

    function contribution() public payable //contribution should be in wei because we are calculating number of share according to it
    {
        require(contributionTimeEnd>=block.timestamp,"contribution time is over");
        require(msg.value>0,"you have to increase your funds");
        is_invester[msg.sender]=true;
        numOfshares[msg.sender]=numOfshares[msg.sender]+msg.value;
        totalShares+=msg.value;
        available_funds+=msg.value;
        investor_list.push(msg.sender);

    }

    function withdrawShares(uint amount) public onlyInvester() 
    {
        require(numOfshares[msg.sender]>=amount,"you dint have enough shares ");
        require(available_funds>=amount,"not enough funds in contract");
        numOfshares[msg.sender]-=amount;
        if(numOfshares[msg.sender]==0)
        {
            is_invester[msg.sender]==false;
        }
        available_funds-=amount;
        payable (msg.sender).transfer(amount);
    }

    function transferShare(uint amount ,address to) public onlyInvester()
    {
        require(numOfshares[msg.sender]>=amount,"you dont have enough amount of shares to send it to another");
        require(is_invester[msg.sender]==true,"you are not shares holder , so you cannot transfer the shares ");
        numOfshares[msg.sender]-=amount;
        numOfshares[to]+=amount;
        if(numOfshares[msg.sender]==0)
        {
            is_invester[msg.sender]=false;
        }
        is_invester[to]=true;

    }

    function createProposal(string calldata description,uint amount,address payable resepient) public
    {
        require(available_funds>=amount,"not enough funds");
        proposals[nextProposalId]=Proposal(nextProposalId,description,amount,resepient,0,block.timestamp+voteTime,false);
        nextProposalId++;
    }

    function voteProposal (uint proposalId) public onlyInvester()
    {
        Proposal storage proposal=proposals[proposalId];
        require(isVoted[msg.sender][proposalId]==false,"you have alredy voted for proporsal");
        require(proposal.end>=block.timestamp,"voting time ended");
        require(proposal.isExecuted==false,"it is alredy executed");
        isVoted[msg.sender][proposalId]=true;
        proposal.votes+=numOfshares[msg.sender];

        
    }
    function executeProposal(uint proposalId) public onlyManager()
    {
        
        Proposal storage proposal=proposals[proposalId];
        require(proposal.isExecuted==false,"you have alredy got your amount fucker ");
        require(((proposal.votes*100)/totalShares)>=quorum,"majority does not support");
        proposal.isExecuted=true;
        available_funds-=proposal.amount;
        _transfer(proposal.amount,proposal.receipient);
    }
    function _transfer(uint amount,address payable recever) private {
        recever.transfer(amount);
    }

    function proposallist() public view returns(Proposal[] memory)

    {
        Proposal[] memory arr=new Proposal[](nextProposalId-1);//beacuse nextproposal id is one more than real because it increment when we added value
        for(uint i=0; i<nextProposalId-1; i++)
        {
            arr[i]=proposals[i];//we transferred it to array becausse we cannot retun mapping from function

        }
        return arr;

    }
    

}
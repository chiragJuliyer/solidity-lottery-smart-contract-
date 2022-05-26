
// SPDX-License-Identifier: MIT


pragma solidity ^0.8.0;

contract CrowdFunding{
    mapping(address => uint) public contributors;
    address public manager;
    uint public minimumcontribution;
    uint public deadline;
    uint public target;
    uint public raisedamount;
    uint public noofcontributors;
    
    struct Request{
        string Description;
        address payable recipient;
        uint value;
        bool completed;
        uint noofvoters;
        mapping(address => bool) voters;
    }
    mapping(uint=> Request) public requests;
    uint public numRequests;
    

    constructor(uint _target , uint _deadline){
        target=_target;
        deadline=  block.timestamp + _deadline;
        minimumcontribution=100 wei;
        manager=msg.sender;

    }
    function sendEth()  public payable {
        require(block.timestamp<deadline, "deadline has passed");
        require(msg.value>=minimumcontribution,"min contribution not met");
        
    
    if(contributors[msg.sender]==0) {
        noofcontributors++; 
    }

    
    contributors[msg.sender]+=msg.value;
    raisedamount+=msg.value;
  
    }
    function getContractBalance() public view returns(uint) {
        return address(this).balance;
        
    }
    function refund() public {
        require(block.timestamp>deadline && raisedamount<target,"you are not elgible");
        require(contributors[msg.sender]>0);
        address payable user=payable(msg.sender);
        user.transfer(contributors[msg.sender]); 
        contributors[msg.sender]=0;

    }
    modifier onlymangr(){
        require(msg.sender==manager,"onlu manager can call this function");
        _;
    }
    function createRequests(string memory _description , address payable _recipient, uint _value) public onlymangr{
        Request storage newRequest = requests[numRequests];
        numRequests++;
        newRequest.Description=_description;
        newRequest.recipient=_recipient;
        newRequest.value=_value;
        newRequest.completed=false;
        newRequest.noofvoters=0;
    }
    function voteRequest(uint _requestno) public {
        require(contributors[msg.sender]>0,"you must be contributor");
        Request storage thisRequest=requests[_requestno];
        require(thisRequest.voters[msg.sender]==false,"you have already voted");
        thisRequest.voters[msg.sender]=true;
        thisRequest.noofvoters++;
    }
       
    function makePayment(uint _requestno) public onlymangr {
        require(raisedamount>=target);
        Request storage thisRequest=requests[_requestno];
        require(thisRequest.completed==false,"The request has been completed");
        require(thisRequest.noofvoters > noofcontributors/2,"Majority does not support");
        thisRequest.recipient.transfer(thisRequest.value);
        thisRequest.completed=true;
    }


 
}
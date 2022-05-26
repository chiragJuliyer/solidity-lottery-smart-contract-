//SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.5.0 <0.9.0;

contract token{
    string public name="hardhattoken";
    string public symbol ="hht";
    uint  public totalsupply =10000;

    address public owner;
    mapping(address => uint)  balances;

constructor() {
    balances[msg.sender] = totalsupply;
    owner=msg.sender;

}
function transfer(address to , uint256 amount)   external {
    require(balances[msg.sender]>=amount, "not enough token");
    balances[msg.sender]-=amount;
    balances[to]+=amount;
}
function balanceof(address account) external view returns(uint256){
    return balances[account];
}
}


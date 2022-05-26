// SPDX-License-Identifier: MIT


pragma solidity ^0.8.0;
contract lottery{
    address public manager;
    address payable[] public players;
    
    constructor(){
        manager=msg.sender;
    } 

    function alreadyentered() view private returns(bool){
        for(uint i=0; i<players.length; i++){
            if (players[i]==msg.sender)
            return true;
        }
        return false;
    }

    function enter() payable public {
        require(msg.sender!=manager , "manager cant enter");
        require(alreadyentered()==false, "player already entered");
        require(msg.value >= 1 ether , " min amount more than 1 ether");
        players.push(payable(msg.sender));
    }

    function random() view private returns(uint){
        return uint(sha256(abi.encodePacked(block.difficulty,block.number,players)));
    
    }
    function pickwinner() public {
        require(msg.sender==manager , "only manager can pickwinner");
         uint index = random()%players.length;
         address contractadress= address(this);
         players[index].transfer(contractadress.balance);
         players=new address payable[](0);
    }
    function getplayers() view public returns(address payable[] memory) {
        return players;

    }
    

}

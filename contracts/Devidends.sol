// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.8.0;

import "browser/DudleToken.sol";

contract Devidends is DudleToken {
    mapping(address => uint256) lastDivideRewardTime;
    
    function deposit () public payable {
        totalReward = msg.value;
    }
    
    function takeReward () public {
        require(lastDivideRewardTime[msg.sender] + 2 minutes < block.timestamp);
        lastDivideRewardTime[msg.sender] = block.timestamp;
        msg.sender.transfer(totalReward * balances[msg.sender] / totalSupply);
        if (address(this).balance == 0) {
            totalReward = 0;
        }
    }
    
    function getBalance () public view onlyOwner returns(uint256) {
        return address(this).balance;
    }
}
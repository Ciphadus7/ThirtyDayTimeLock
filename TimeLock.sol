// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19 ;

contract ThirtyDayTimeLock{


    address public owner;
    bool internal locked;
    mapping(address => uint256) internal userBalance;
    mapping(address => uint256) internal depositTimestamp;

    constructor() {
        owner = msg.sender;
    }

    modifier noReentrancy(){    
        require(!locked, "NOPE NOPE");
        locked = true;
        _;
        locked = false;
    }

    function Deposit() public payable noReentrancy {
        userBalance[msg.sender] += msg.value;
        depositTimestamp[msg.sender] = block.timestamp;
    }

    function Withdraw() public payable noReentrancy{
        require(depositTimestamp[msg.sender] <= block.timestamp + 30 days, "The transaction is still locked.");
        payable(msg.sender).transfer(userBalance[msg.sender]);
    }

}
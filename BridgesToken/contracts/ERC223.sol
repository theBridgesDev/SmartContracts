pragma solidity ^0.4.0;

/**
* @dev Specifies the main characteristics of an ERC223 token.
* SPDX-License-Identifier: MIT
*/

interface ERC223 {
    function transfer(address toAddr, uint value, bytes data) public returns (bool);
    event Transfer(address indexed fromAddr, address indexed toAddr, uint value, bytes indexed data);
}

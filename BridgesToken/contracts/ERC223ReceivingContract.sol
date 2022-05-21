pragma solidity ^0.4.0;

/**
* @dev Specifies the main characteristics of a contract receiving the ERC223 token.
* SPDX-License-Identifier: MIT
*/

contract ERC223ReceivingContract {
    function tokenFallback(address fromAddr, uint value, bytes data) public;
}

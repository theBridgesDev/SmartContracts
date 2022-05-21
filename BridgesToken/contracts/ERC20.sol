pragma solidity ^0.4.0;

/**
* @dev Specifies the main characteristics of an ERC20 token.
* SPDX-License-Identifier: MIT
*/

interface ERC20 {
    function totalSupply() external constant returns (uint totalTokenSupply);
    function balanceOf(address owner) external constant returns (uint balance);
    function transfer(address toAddr, uint value) external returns (bool success);
    function transferFrom(address fromAddr, address toAddr, uint value) external returns (bool success);
    function approve(address spender, uint value) external returns (bool success);
    function allowance(address owner, address spender) external constant returns (uint remaining);
    event Transfer(address indexed fromAddr, address indexed toAddr, uint value);
    event Approval(address indexed owner, address indexed spender, uint value);
}

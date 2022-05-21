pragma solidity ^0.4.0;

/**
* @dev Importing ERC standards for Bridges token.
* SPDX-License-Identifier: MIT
*/
import "./ERC20.sol";
import "./ERC223.sol";
import "./ERC223ReceivingContract.sol";

/**
* @dev Specifies the main characteristics of the Bridges token contract.
*/

contract BridgesToken is ERC20, ERC223 {

    string public constant _tokenName = "Bridges Token";
    string public constant _tokenSymbol = "AIP";
    uint8 public constant _tokenDecimal = 18;

    uint256 private constant _totalTokenSupply = 1337000000000000000000;

    mapping (address => uint256) public _balanceOf;
    mapping (address => mapping (address => uint256)) public _allowances;

    /**
    * @dev Assigns the total token supply to the contract creator. Only runs once when
    * the contract is first created.
    */

    constructor() public {
        _balanceOf[msg.sender] = _totalTokenSupply;
    }

    /**
    * @dev Returns the name of the cryptocurrency token.
    */

    function name() public constant returns (string tokenName) {
        tokenName = _tokenName;
    }

    /**
    * @dev Returns the ticker of the cryptocurrency token.
    */

    function symbol() public constant returns (string tokenSymbol) {
        tokenSymbol = _tokenSymbol;
    }

    /**
    * @dev Returns the number of decimals.
    */

    function decimals() public view returns (uint8 tokenDecimal) {
        tokenDecimal = _tokenDecimal;
    }

    /**
    * @dev Returns the total circulating supply of the token.
    */

    function totalSupply() public view returns (uint256 totalTokenSupply) {
        totalTokenSupply = _totalTokenSupply;
    }

    /**
    * @dev Returns the total balance for a given address.
    */

    function balanceOf(address owner) public constant returns (uint256 balance) {
        return _balanceOf[owner];
    }

    /**
    * @dev Transfers the specified number of tokens to a non smart-contract target
    * address if the number of tokens to transfer is greater than zero and less than or
    * equal to the sender's balance. Logs a Transfer() event and returns success if the
    * previous statement is true, otherwise return false.
    */

    function transfer(address toAddr, uint256 value) public returns (bool success) {
        if (value > 0 &&
            value <= _balanceOf[msg.sender] &&
            !isContract(toAddr)) {
                _balanceOf[msg.sender] -= value;
                _balanceOf[toAddr] += value;
                Transfer(msg.sender, toAddr, value);
                return true;
        }
        return false;
    }

    /**
    * @dev Determines if a given address is a smart contract or not.
    */

    function isContract(address addr) returns (bool) {
        uint codeSize;
        assembly {
            codeSize := extcodesize(addr)
        }
        return codeSize > 0;
    }

    /**
    * @dev Transfers the specified number of tokens to a target smart-contract address if
    * the number of tokens to transfer is greater than zero and less than or equal to the
    * sender's balance. Logs a Transfer() event and returns success if the previous
    * statement is true, otherwise return false.
    */

    function transfer(address toAddr, uint value, bytes data) public returns (bool) {
        if (value > 0 &&
            value <= _balanceOf[msg.sender] &&
            isContract(toAddr)) {
                _balanceOf[msg.sender] -= value;
                _balanceOf[toAddr] += value;
                ERC223ReceivingContract _contract = ERC223ReceivingContract(toAddr);
                _contract.tokenFallback(msg.sender, value, data);
                Transfer(msg.sender, toAddr, value, data);
                return true;
        }
        return false;
    }

    /**
    * @dev Performs a transfer of a specified number of tokens from a source address to
    * a target address if the sender has a transfer allowance greater than zero, the number
    * of tokens to transfer is greater than zero and less than or equal to the sender's
    * transfer allowance while also being less than or equal to the source's balance. Logs
    * a Transfer() event and returns success if the previous statement is true, otherwise
    * returns false.
    */

    function transferFrom(address fromAddr, address toAddr, uint256 value) public returns (bool success) {
        if (_allowances[fromAddr][msg.sender] > 0 &&
            value > 0 &&
            value <= _allowances[fromAddr][msg.sender] &&
            value <= _balanceOf[fromAddr]) {
                _balanceOf[fromAddr] -= value;
                _balanceOf[toAddr] += value;
                _allowances[fromAddr][msg.sender] -= value;
                Transfer(fromAddr, toAddr, value);
                return true;
        }
        return false;
    }

    /**
    * @dev The owner can specify the number of tokens that can be transferred (allowance)
    * for a particular address. An Approval() event is logged.
    */

    function approve(address spender, uint256 value) public returns (bool success) {
        _allowances[msg.sender][spender] = value;
        Approval(msg.sender, spender, value);
        return true;
    }

    /**
    * @dev Returns the total remaining number of tokens allowed to be transferred (allowance)
    * for a particular address.
    */

    function allowance(address owner, address spender) public constant returns (uint256 remaining) {
        return _allowances[owner][spender];
    }
}

// SPDX-License-Identifier: MIT
pragma solidity 0.8.22;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

/**
 * @title Wallet Contract
 * @dev A simple Ethereum wallet contract that allows users to deposit and withdraw ERC20 tokens.
 * Users can check their token balances and on-hold balances.
 */
contract Wallet {
    // Mapping to track user balances for each token
    mapping(address => mapping(address => uint)) private balances;

    // Mapping to track on-hold balances for each token
    mapping(address => mapping(address => uint)) private onHold;

    /**
     * @dev Constructor function
     */
    constructor() {}

    /**
     * @dev Get the balance of a user for a specific token.
     * @param user The address of the user.
     * @param token The address of the ERC20 token.
     * @return The user's balance for the specified token.
     */
    function balanceOf(address user, address token) public view returns (uint) {
        return balances[user][token];
    }

    /**
     * @dev Get the on-hold balance of a user for a specific token.
     * @param user The address of the user.
     * @param token The address of the ERC20 token.
     * @return The user's on-hold balance for the specified token.
     */
    function onHoldBalanceOf(address user, address token)
        public
        view
        returns (uint)
    {
        return onHold[user][token];
    }

    /**
     * @dev Deposit ERC20 tokens into the wallet.
     * @param token The address of the ERC20 token to deposit.
     * @param amount The amount of tokens to deposit.
     */
    function deposit(address token, uint amount) external {
        // Transfer tokens from the user to the contract
        IERC20(token).transferFrom(msg.sender, address(this), amount);

        // Update the user's balance
        balances[msg.sender][token] += amount;
    }

    /**
     * @dev Withdraw ERC20 tokens from the wallet.
     * @param token The address of the ERC20 token to withdraw.
     * @param amount The amount of tokens to withdraw.
     */
    function withdraw(address token, uint amount) external {
        // Check if the user has sufficient balance
        require(balanceOf(msg.sender, token) >= amount, "Insufficient balance");

        // Transfer tokens from the contract to the user
        IERC20(token).transfer(msg.sender, amount);

        // Update the user's balance
        balances[msg.sender][token] -= amount;
    }
}

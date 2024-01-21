// SPDX-License-Identifier: MIT
pragma solidity 0.8.22;

import "@openzeppelin/contracts/proxy/utils/Initializable.sol";

contract Book is Initializable {
    struct Order {
        uint id;
        uint price;
        uint amount;
    }

    uint lastOrderId;

    Order[] public asks;
    Order[] public bids;

    constructor() {
        _disableInitializers();
    }

    function initialize() public initializer {}

    function place(uint price, uint amount) {
        lastOrderId += 1;
        Order _order = Order(lastOrderId, price, amount);
    }

// TODO
    function cancel(uint id, uint isAsk) {
        lastOrderId += 1;
        Order _order = Order(lastOrderId, price, amount);
    }
}

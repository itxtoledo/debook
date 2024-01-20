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

    constructor() {
        _disableInitializers();
    }

    function initialize() public initializer {}

    function place(uint price, uint amount) {
        uint newOrderId = lastOrderId + 1;
        Order _order = Order(newOrderId, price, amount);
    }
}

// SPDX-License-Identifier: MIT
pragma solidity 0.8.22;

import "@openzeppelin/contracts/proxy/utils/Initializable.sol";

contract Book is Initializable {
    struct Order {
        uint256 price;
        uint256 amount;
    }

    constructor() {
        _disableInitializers();
    }

    function initialize() public initializer {}

    function place() {}
}

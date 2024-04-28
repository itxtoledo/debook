// SPDX-License-Identifier: MIT
pragma solidity 0.8.22;

import "@openzeppelin/contracts/proxy/utils/Initializable.sol";

contract Book is Initializable {
    struct Order {
        uint id;
        uint price;
        // TODO check if need availableAmount and originalAmount
        uint amount;
    }

    uint lastOrderId;

    Order[] public asks;
    Order[] public bids;

    constructor() {
        _disableInitializers();
    }

    function initialize() public initializer {}

    function place(uint price, uint amount, uint8 isAsk) {
        lastOrderId += 1;
        Order _order = Order(lastOrderId, price, amount);

        if (isAsk == 1) {
            if (bids[0].price >= price) {
                // fill immediately
            } else {
                asks.push(_order);
            }
        } else {
            if (asks[0].price <= price) {
                // fill immediately
            } else {
                bids.push(_order);
            }
        }
    }

    // TODO
    function cancel(uint id, uint8 isAsk) {
        if (isAsk == 1) {
            for (uint i = 0; i < asks.length; i++) {
                if (asks[i].id == id) {
                    delete asks[i];
                    break;
                }
            }
        } else {
            for (uint i = 0; i < bids.length; i++) {
                if (bids[i].id == id) {
                    delete bids[i];
                    break;
                }
            }
        }
    }
}

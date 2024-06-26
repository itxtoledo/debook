// SPDX-License-Identifier: MIT
pragma solidity 0.8.22;

import "@openzeppelin/contracts/proxy/utils/Initializable.sol";

contract Book is Initializable {
    event Execution(uint indexed id, uint price, uint amount, bool isAsk);

    struct Transaction {
        bool isBase;
        uint credit;
        uint debit;
    }

    struct Order {
        uint id;
        uint price;
        uint originalAmount;
        uint remainingAmount;
    }

    uint lastOrderId;

    Order[] public asks;
    Order[] public bids;

    constructor() {
        _disableInitializers();
    }

    function initialize() public initializer {}

    function computeChange(
        Order activeOrder,
        Order passiveOrder,
        uint amountTraded,
        bool isAsk
    ) internal returns (uint change) {
        if (!isAsk) {
            change =
                (activeOrder.price * amountTraded) -
                (passiveOrder.price * passiveOrder.remainingAmount);
        }
    }

    function place(
        uint price,
        uint amount,
        uint8 isAsk
    ) external returns (Transaction[] memory transactions) {
        lastOrderId += 1;
        Order activeOrder = Order(lastOrderId, price, amount, amount);

        bool matching = true;

        do {
            Order[] reflexiveSide = isAsk ? bids : asks;

            if (reflexiveSide.length > 0) {
                Order passiveOrder = reflexiveSide[0];
                if (
                    isAsk
                        ? passiveOrder.price >= activeOrder.price
                        : passiveOrder.price <= activeOrder.price
                ) {
                    if (
                        activeOrder.remainingAmount >
                        passiveOrder.remainingAmount
                    ) {
                        // partial active order execution
                        uint amountTraded = passiveOrder.remainingAmount;
                        passiveOrder.remainingAmount = 0;
                        activeOrder.remainingAmount -= amountTraded;

                        uint change = computeChange(
                            activeOrder,
                            passiveOrder,
                            amountTraded,
                            isAsk
                        );

                        // delete reflexiveSide[0];
                        // partial passive order execution
                    } else if (
                        activeOrder.remainingAmount <
                        passiveOrder.remainingAmount
                    ) {
                        uint amountTraded = activeOrder.remainingAmount;
                        passiveOrder.remainingAmount -= amountTraded;
                        activeOrder.remainingAmount = 0;

                        uint change = computeChange(
                            activeOrder,
                            passiveOrder,
                            amountTraded,
                            isAsk
                        );

                        // delete activeOrder;
                    } else {
                        // filled both orders
                        uint amountTraded = passiveOrder.remainingAmount;

                        uint change = computeChange(
                            activeOrder,
                            passiveOrder,
                            amountTraded,
                            isAsk
                        );

                        // delete activeOrder;
                        // delete reflexiveSide[0];
                    }
                }
            }
            matching = false;
        } while (matching);
    }

    // TODO
    function cancel(uint id, bool isAsk) {
        if (isAsk) {
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

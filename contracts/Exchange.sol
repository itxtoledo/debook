// SPDX-License-Identifier: MIT
pragma solidity 0.8.22;

import "@openzeppelin/contracts/proxy/Clones.sol";

import "./Book.sol";
import "./Wallet.sol";

contract Exchange {
    Wallet immutable wallet;
    Book immutable bookImplemmentation;

    // quote -> base -> Book
    mapping(address => mapping(address => address)) books;

    constructor(address wallet_, address bookImplemmentation_) {
        wallet = wallet_;
        bookImplemmentation = bookImplemmentation_;
    }

    function place(
        address base,
        address quote,
        uint price,
        uint amount,
        uint isAsk,
    ) external {
        require(wallet.balanceOf(msg.sender, token) > amount);

        if (books[quote][base] == address(0)) {
            address clone = Clones.clone(bookImplemmentation);
            Book(clone).initialize();
            books[quote][base] = clone;
        }

        books[quote][base].place();
    }

    function cancel(
        address base,
        address quote,
        uint id,
        uint isAsk,
    ) external {
        books[quote][base].cancel(id, isAsk);
    }
}

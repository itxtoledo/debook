// SPDX-License-Identifier: MIT
pragma solidity 0.8.22;

import "@openzeppelin/contracts/proxy/Clones.sol";
import "Errors.sol";
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

    function createBook(address base, address quote) external {
        require(books[quote][base] == address(0), Errors.BookAlreadyExists());

        address clone = Clones.clone(bookImplemplementation);
        Book(clone).initialize();
        books[quote][base] = clone;
    }

    function place(
        address base,
        address quote,
        uint price,
        uint amount,
        uint8 isAsk
    ) external {
        require(books[quote][base] != address(0), Errors.BookNotFound());
        require(
            wallet.balanceOf(msg.sender, token) > amount,
            Errors.InsufficientBalance()
        );

        books[quote][base].place(price, amount, isAsk);
    }

    function cancel(
        address base,
        address quote,
        uint id,
        uint8 isAsk
    ) external {
        books[quote][base].cancel(id, isAsk);
    }
}

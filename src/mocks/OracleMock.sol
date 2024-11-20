// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import {IOracle} from "@canal/interfaces/IOracle.sol";

contract OracleMock is IOracle {
    uint256 public price;

    function setPrice(uint256 newPrice) external {
        price = newPrice;
    }
}
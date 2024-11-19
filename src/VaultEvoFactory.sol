// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import {IVaultEvo} from "./interfaces/IVaultEvo.sol";
import {IVaultEvoFactory} from "./interfaces/IVaultEvoFactory.sol";

import {EventsLib} from "./libraries/EventsLib.sol";
import {ErrorsLib} from "./libraries/ErrorsLib.sol";

import {VaultEvo} from "./VaultEvo.sol";


/// @notice This contract allows to create evo vaults, and to index them easily.

contract VaultEvoFactory is IVaultEvoFactory {
    /* IMMUTABLES */

    address public immutable CANAL;

    /* STORAGE */

    mapping(address => bool) public isVaultEvo;

    /* CONSTRUCTOR */

    /// @dev Initializes the contract.
    /// @param canal The address of the Canal contract.
    constructor(address canal) {
        if (canal == address(0)) revert ErrorsLib.ZeroAddress();

        CANAL = canal;
    }

    /* EXTERNAL */

    function createVaultEvo(
        address initialOwner,
        uint256 initialTimelock,
        address asset,
        string memory name,
        string memory symbol,
        bytes32 salt
    ) external returns (IVaultEvo vaultEvo) {
        vaultEvo =
            IVaultEvo(address(new VaultEvo{salt: salt}(initialOwner, CANAL, initialTimelock, asset, name, symbol)));

        isVaultEvo[address(vaultEvo)] = true;

        emit EventsLib.CreateVaultEvo(
            address(vaultEvo), msg.sender, initialOwner, initialTimelock, asset, name, symbol, salt
        );
    }
}
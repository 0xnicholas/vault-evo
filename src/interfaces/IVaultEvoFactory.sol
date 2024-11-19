// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import {IVaultEvo} from "./IVaultEvo.sol";

interface IVaultEvoFactory {

    function CANAL() external view returns (address);

    function isVaultEvo(address target) external view returns (bool);

    /// @notice Creates a new Evo vault.
    /// @param initialOwner The owner of the vault.
    /// @param initialTimelock The initial timelock of the vault.
    /// @param asset The address of the underlying asset.
    /// @param name The name of the vault.
    /// @param symbol The symbol of the vault.
    /// @param salt The salt to use for the Evo vault's CREATE2 address.
    function createVaultEvo(
        address initialOwner,
        uint256 initialTimelock,
        address asset,
        string memory name,
        string memory symbol,
        bytes32 salt
    ) external returns (IVaultEvo vaultEvo);
}
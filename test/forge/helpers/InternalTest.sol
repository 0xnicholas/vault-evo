// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "./BaseTest.sol";
import {VaultEvo} from "@vault-evo/VaultEvo.sol";

contract InternalTest is BaseTest, VaultEvo {
    constructor()
        VaultEvo(OWNER, address(canal), ConstantsLib.MIN_TIMELOCK, address(loanToken), "Evo Vault", "EV")
    {}

    function setUp() public virtual override {
        super.setUp();

        vm.startPrank(OWNER);
        this.setCurator(CURATOR);
        this.setIsAllocator(ALLOCATOR, true);
        vm.stopPrank();

        vm.startPrank(SUPPLIER);
        loanToken.approve(address(this), type(uint256).max);
        collateralToken.approve(address(this), type(uint256).max);
        vm.stopPrank();
    }
}
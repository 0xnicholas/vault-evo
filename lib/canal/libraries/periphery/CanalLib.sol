// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import {ICanal, Id} from "../../interfaces/ICanal.sol";
import {CanalStorageLib} from "./CanalStorageLib.sol";

library CanalLib {
    function supplyShares(ICanal canal, Id id, address user) internal view returns (uint256) {
        bytes32[] memory slot = _array(CanalStorageLib.positionSupplySharesSlot(id, user));
        return uint256(canal.extSloads(slot)[0]);
    }

    function borrowShares(ICanal canal, Id id, address user) internal view returns (uint256) {
        bytes32[] memory slot = _array(CanalStorageLib.positionBorrowSharesAndCollateralSlot(id, user));
        return uint128(uint256(canal.extSloads(slot)[0]));
    }

    function collateral(ICanal canal, Id id, address user) internal view returns (uint256) {
        bytes32[] memory slot = _array(CanalStorageLib.positionBorrowSharesAndCollateralSlot(id, user));
        return uint256(canal.extSloads(slot)[0] >> 128);
    }

    function totalSupplyAssets(ICanal canal, Id id) internal view returns (uint256) {
        bytes32[] memory slot = _array(CanalStorageLib.marketTotalSupplyAssetsAndSharesSlot(id));
        return uint128(uint256(canal.extSloads(slot)[0]));
    }

    function totalSupplyShares(ICanal canal, Id id) internal view returns (uint256) {
        bytes32[] memory slot = _array(CanalStorageLib.marketTotalSupplyAssetsAndSharesSlot(id));
        return uint256(canal.extSloads(slot)[0] >> 128);
    }

    function totalBorrowAssets(ICanal canal, Id id) internal view returns (uint256) {
        bytes32[] memory slot = _array(CanalStorageLib.marketTotalBorrowAssetsAndSharesSlot(id));
        return uint128(uint256(canal.extSloads(slot)[0]));
    }

    function totalBorrowShares(ICanal canal, Id id) internal view returns (uint256) {
        bytes32[] memory slot = _array(CanalStorageLib.marketTotalBorrowAssetsAndSharesSlot(id));
        return uint256(canal.extSloads(slot)[0] >> 128);
    }

    function lastUpdate(ICanal canal, Id id) internal view returns (uint256) {
        bytes32[] memory slot = _array(CanalStorageLib.marketLastUpdateAndFeeSlot(id));
        return uint128(uint256(canal.extSloads(slot)[0]));
    }

    function fee(ICanal canal, Id id) internal view returns (uint256) {
        bytes32[] memory slot = _array(CanalStorageLib.marketLastUpdateAndFeeSlot(id));
        return uint256(canal.extSloads(slot)[0] >> 128);
    }

    function _array(bytes32 x) private pure returns (bytes32[] memory) {
        bytes32[] memory res = new bytes32[](1);
        res[0] = x;
        return res;
    }
}
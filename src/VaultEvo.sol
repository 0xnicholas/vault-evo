// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import {
    MarketConfig,
    PendingUint192,
    PendingAddress,
    MarketAllocation,
    IVaultEvoBase,
    IVaultEvoStaticTyping
} from "./interfaces/IVaultEvo.sol";

/// example of market: canal
import {Id, MarketParams, Market, ICanal} from "@canal/interfaces/ICanal.sol";

import {PendingUint192, PendingAddress, PendingLib} from "./libraries/PendingLib.sol";
import {ConstantsLib} from "./libraries/ConstantsLib.sol";
import {ErrorsLib} from "./libraries/ErrorsLib.sol";
import {EventsLib} from "./libraries/EventsLib.sol";

import {WAD} from "@canal/libraries/MathLib.sol";
import {UtilsLib} from "@canal/libraries/UtilsLib.sol";
import {SafeCast} from "@openzeppelin/contracts/utils/math/SafeCast.sol";
import {SharesMathLib} from "@canal/libraries/SharesMathLib.sol";
import {MarketParamsLib} from "@canal/libraries/MarketParamsLib.sol";

import {CanalLib} from "@canal/libraries/periphery/CanalLib.sol";
import {CanalBalancesLib} from "@canal/libraries/periphery/CanalBalancesLib.sol";


import {IERC20Metadata} from "@openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol";
import {Multicall} from "@openzeppelin/contracts/utils/Multicall.sol";
import {Ownable2Step, Ownable} from "@openzeppelin/contracts/access/Ownable2Step.sol";
import {ERC20Permit} from "@openzeppelin/contracts/token/ERC20/extensions/ERC20Permit.sol";
import {
    IERC20,
    IERC4626,
    ERC20,
    ERC4626,
    Math,
    SafeERC20
} from "@openzeppelin/contracts/token/ERC20/extensions/ERC4626.sol";


contract VaultEvo {


}
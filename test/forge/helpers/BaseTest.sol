// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "@canal/interfaces/ICanal.sol";

import {WAD, MathLib} from "@canal/libraries/MathLib.sol";
import {Math} from "@openzeppelin/contracts/utils/math/Math.sol";
import {MarketParamsLib} from "@canal/libraries/MarketParamsLib.sol";
import {CanalLib} from "@canal/libraries/periphery/CanalLib.sol";
import {CanalBalancesLib} from "@canal/libraries/periphery/CanalBalancesLib.sol";

import "@vault-evo/interfaces/IVaultEvo.sol";

import "@vault-evo/libraries/ConstantsLib.sol";
import {ErrorsLib} from "@vault-evo/libraries/ErrorsLib.sol";
import {EventsLib} from "@vault-evo/libraries/EventsLib.sol";
import {ORACLE_PRICE_SCALE} from "@canal/libraries/ConstantsLib.sol";

import {IrmMock} from "@vault-evo/mocks/IrmMock.sol";
import {ERC20Mock} from "@vault-evo/mocks/ERC20Mock.sol";
import {OracleMock} from "@vault-evo/mocks/OracleMock.sol";

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

import {IERC20, ERC20} from "@openzeppelin/contracts/token/ERC20/extensions/ERC4626.sol";

import "@forge-std/Test.sol";
import "@forge-std/console2.sol";

uint256 constant BLOCK_TIME = 1;
uint256 constant MIN_TEST_ASSETS = 1e8;
uint256 constant MAX_TEST_ASSETS = 1e28;
uint184 constant CAP = type(uint128).max;
uint256 constant NB_MARKETS = ConstantsLib.MAX_QUEUE_LENGTH + 1;

contract BaseTest is Test {

    using MathLib for uint256;
    using CanalLib for ICanal;
    using CanalBalancesLib for ICanal;
    using MarketParamsLib for MarketParams;

    address internal OWNER = makeAddr("Owner");
    address internal SUPPLIER = makeAddr("Supplier");
    address internal BORROWER = makeAddr("Borrower");
    address internal REPAYER = makeAddr("Repayer");
    address internal ONBEHALF = makeAddr("OnBehalf");
    address internal RECEIVER = makeAddr("Receiver");
    address internal ALLOCATOR = makeAddr("Allocator");
    address internal CURATOR = makeAddr("Curator");
    address internal GUARDIAN = makeAddr("Guardian");
    address internal FEE_RECIPIENT = makeAddr("FeeRecipient");
    address internal SKIM_RECIPIENT = makeAddr("SkimRecipient");
    address internal CANAL_OWNER = makeAddr("CanalOwner");
    address internal CANAL_FEE_RECIPIENT = makeAddr("CanalFeeRecipient");

    ICanal internal canal = ICanal(deployCode("Canal.sol", abi.encode(CANAL_OWNER)));
    ERC20Mock internal loanToken = new ERC20Mock("loan", "B");
    ERC20Mock internal collateralToken = new ERC20Mock("collateral", "C");
    OracleMock internal oracle = new OracleMock();
    IrmMock internal irm = new IrmMock();

    MarketParams[] internal allMarkets;
    MarketParams internal idleParams;

    function setUp() public virtual {
        vm.label(address(canal), "Canal");
        vm.label(address(loanToken), "Loan");
        vm.label(address(collateralToken), "Collateral");
        vm.label(address(oracle), "Oracle");
        vm.label(address(irm), "Irm");

        oracle.setPrice(ORACLE_PRICE_SCALE);

        irm.setApr(0.5 ether); // 50%.

        idleParams = MarketParams({
            loanToken: address(loanToken),
            collateralToken: address(0),
            oracle: address(0),
            irm: address(irm),
            lltv: 0
        });

        vm.startPrank(CANAL_OWNER);
        canal.enableIrm(address(irm));
        canal.setFeeRecipient(CANAL_FEE_RECIPIENT);

        canal.enableLltv(0);
        vm.stopPrank();

        canal.createMarket(idleParams);

        for (uint256 i; i < NB_MARKETS; ++i) {
            uint256 lltv = 0.8 ether / (i + 1);

            MarketParams memory marketParams = MarketParams({
                loanToken: address(loanToken),
                collateralToken: address(collateralToken),
                oracle: address(oracle),
                irm: address(irm),
                lltv: lltv
            });

            vm.prank(CANAL_OWNER);
            canal.enableLltv(lltv);

            canal.createMarket(marketParams);

            allMarkets.push(marketParams);
        }

        allMarkets.push(idleParams); // Must be pushed last.

        vm.startPrank(SUPPLIER);
        loanToken.approve(address(canal), type(uint256).max);
        collateralToken.approve(address(canal), type(uint256).max);
        vm.stopPrank();

        vm.prank(BORROWER);
        collateralToken.approve(address(canal), type(uint256).max);

        vm.prank(REPAYER);
        loanToken.approve(address(canal), type(uint256).max);
    }

    /// @dev Rolls & warps the given number of blocks forward the blockchain.
    function _forward(uint256 blocks) internal {
        vm.roll(block.number + blocks);
        vm.warp(block.timestamp + blocks * BLOCK_TIME); // Block speed should depend on test network.
    }

    /// @dev Bounds the fuzzing input to a realistic number of blocks.
    function _boundBlocks(uint256 blocks) internal pure returns (uint256) {
        return bound(blocks, 2, type(uint24).max);
    }

    /// @dev Bounds the fuzzing input to a non-zero address.
    /// @dev This function should be used in place of `vm.assume` in invariant test handler functions:
    /// https://github.com/foundry-rs/foundry/issues/4190.
    function _boundAddressNotZero(address input) internal view virtual returns (address) {
        return address(uint160(bound(uint256(uint160(input)), 1, type(uint160).max)));
    }

    function _accrueInterest(MarketParams memory market) internal {
        collateralToken.setBalance(address(this), 1);
        canal.supplyCollateral(market, 1, address(this), hex"");
        canal.withdrawCollateral(market, 1, address(this), address(10));
    }

    /// @dev Returns a random market params from the list of markets enabled on Blue (except the idle market).
    function _randomMarketParams(uint256 seed) internal view returns (MarketParams memory) {
        return allMarkets[seed % (allMarkets.length - 1)];
    }

    function _randomCandidate(address[] memory candidates, uint256 seed) internal pure returns (address) {
        if (candidates.length == 0) return address(0);

        return candidates[seed % candidates.length];
    }

    function _removeAll(address[] memory inputs, address removed) internal pure returns (address[] memory result) {
        result = new address[](inputs.length);

        uint256 nbAddresses;
        for (uint256 i; i < inputs.length; ++i) {
            address input = inputs[i];

            if (input != removed) {
                result[nbAddresses] = input;
                ++nbAddresses;
            }
        }

        assembly {
            mstore(result, nbAddresses)
        }
    }

    function _randomNonZero(address[] memory users, uint256 seed) internal pure returns (address) {
        users = _removeAll(users, address(0));

        return _randomCandidate(users, seed);
    }
}
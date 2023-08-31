// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "./TestUtils.sol";

import "../src/FlashLoan.sol";

import {ERC20Interface} from "../src/FlashLoan.sol";

contract FlashLoanTest is Test, TestUtils {
    FlashLoan public flashLoan;

    // Arbitrum.
    address public constant WETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;

    uint256 public constant INITIAL_WETH = 5 ether;

    uint256 public constant WETH_LOAN = 1000 ether;

    function setUp() public {
        cheat.createSelectFork(vm.rpcUrl("mainnet"));
        flashLoan = new FlashLoan();

        // Wrap Eth.
        (bool success,) = WETH.call{value: INITIAL_WETH}("");
        require(success, "WETH transfer failed");
        console.log("WETH balance: %s", ERC20Interface(WETH).balanceOf(address(this)));
        // We transfer weth to the flash loan contract.
        (success,) =
            WETH.call{value: 0}(abi.encodeWithSignature("transfer(address,uint256)", address(flashLoan), INITIAL_WETH));
        require(success, "WETH transfer failed");

        // We approve the flash loan contract to spend our WETH.
        flashLoan.approve(WETH);
    }

    function testWethBalance() public {
        assertEq(ERC20Interface(WETH).balanceOf(address(flashLoan)), INITIAL_WETH);
    }

    function testWethFlashLoan() public {
        // We execute the flashloan.
        flashLoan.flashloan(WETH, WETH_LOAN);

        // We should have 1000 - 0.05% fee.
        uint256 fee = flashLoan.getCurrentFee();
        assertEq(fee, 5);

        uint256 deductedAmount = WETH_LOAN * fee / 10000;
        assertEq(ERC20Interface(WETH).balanceOf(address(flashLoan)), INITIAL_WETH - deductedAmount);
    }
}

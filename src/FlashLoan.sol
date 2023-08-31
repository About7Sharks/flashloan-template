// SPDX-License-Identifier: MIT
pragma solidity >= 0.8.0;

import "forge-std/Test.sol";

import {AaveInterface} from "./interfaces/AaveInterface.sol";
import {ERC20Interface} from "./interfaces/ERC20Interface.sol";

contract FlashLoan is Test {
    uint256 public number;

    AaveInterface public aave;

    constructor() {
        aave = AaveInterface(0x87870Bca3F3fD6335C3F4ce8392D69350B4fA4E2);
    }

    function getCurrentFee() external view returns (uint128) {
        return aave.FLASHLOAN_PREMIUM_TOTAL();
    }

    function flashloan(address asset, uint256 amount) external {
        aave.flashLoanSimple(address(this), asset, amount, "", 0);
    }

    function executeOperation(address asset, uint256 amount, uint256 premium, address, bytes calldata)
        external
        returns (bool)
    {
        uint256 amountOwed = amount + premium;
        ERC20Interface(asset).approve(address(aave), amountOwed);

        // We should have 1005 weth.
        uint256 wethBalance = ERC20Interface(asset).balanceOf(address(this));
        require(wethBalance == 1005 ether, "flashloan didn't work");

        // Logic goes here
        ///

        return true;
    }

    function approve(address token) external {
        ERC20Interface(token).approve(address(aave), type(uint256).max);
    }
}

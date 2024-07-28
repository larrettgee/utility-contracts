// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.26;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

contract ERC20Escrow is ReentrancyGuard {
    using SafeERC20 for IERC20;

    IERC20 public token1;
    IERC20 public token2;
    uint256 public amount1;
    uint256 public amount2;
    address public recipient1;
    address public recipient2;

    bool private deposit1Made = false;
    bool private deposit2Made = false;

    event Deposit(IERC20 token, uint256 amount, address recipient);
    event CompleteEscrow();
    event EmergencyWithdrawal(address recipient, uint256 amount1, uint256 amount2);

    constructor(
        IERC20 _token1,
        IERC20 _token2,
        uint256 _amount1,
        uint256 _amount2,
        address _recipient1,
        address _recipient2
    ) {
        require(_amount1 > 0 && _amount2 > 0, "Amounts must be greater than zero");

        token1 = _token1;
        token2 = _token2;
        amount1 = _amount1;
        amount2 = _amount2;
        recipient1 = _recipient1;
        recipient2 = _recipient2;
    }

    function deposit1() external {
        require(msg.sender == recipient1, "Caller is not recipient1");
        token1.safeTransferFrom(recipient1, address(this), amount1);
        deposit1Made = true;

        emit Deposit(token1, amount1, recipient1);
    }

    function deposit2() external {
        require(msg.sender == recipient2, "Caller is not recipient2");
        token2.safeTransferFrom(recipient2, address(this), amount2);
        deposit2Made = true;

        emit Deposit(token2, amount2, recipient2);
    }

    function completeEscrow() external nonReentrant {
        require(deposit1Made && deposit2Made, "Deposits not completed");
        token1.safeTransfer(recipient2, amount1);
        token2.safeTransfer(recipient1, amount2);

        emit CompleteEscrow();
    }

    function emergencyWithdraw() external nonReentrant {
        if (msg.sender == recipient1) {
            uint256 balance1 = token1.balanceOf(address(this));
            token1.safeTransfer(recipient1, balance1);
            emit EmergencyWithdrawal(recipient1, balance1, 0);
        } else if (msg.sender == recipient2) {
            uint256 balance2 = token2.balanceOf(address(this));
            token2.safeTransfer(recipient2, balance2);
            emit EmergencyWithdrawal(recipient2, 0, balance2);
        }
    }
}

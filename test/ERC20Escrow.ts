import { loadFixture } from "@nomicfoundation/hardhat-toolbox/network-helpers";
import { expect } from "chai";
import hre, { ethers } from "hardhat";

describe("ERC20Escrow", function () {
  // Fixture to deploy the contract with initial conditions
  async function deployContract() {
    const [owner, recipient1, recipient2] = await hre.ethers.getSigners();
    const amount1 = ethers.parseUnits("1000", 18);
    const amount2 = ethers.parseUnits("2000", 18);

    const Token = await hre.ethers.getContractFactory("MockToken");
    const token1 = await Token.deploy("Token1", "TK1", amount1);
    const token2 = await Token.deploy("Token2", "TK2", amount2);

    const ERC20Escrow = await hre.ethers.getContractFactory("ERC20Escrow");
    const erc20Escrow = await ERC20Escrow.deploy(
      await token1.getAddress(),
      await token2.getAddress(),
      amount1,
      amount2,
      recipient1.address,
      recipient2.address
    );

    // Assume both tokens are ERC20 with an initial supply to owner
    await token1.transfer(recipient1.address, amount1);
    await token2.transfer(recipient2.address, amount2);

    return { erc20Escrow, token1, token2, amount1, amount2, owner, recipient1, recipient2 };
  }

  describe("Deployment", function () {
    it("Should correctly initialize contract variables", async function () {
      const { erc20Escrow, token1, token2, amount1, amount2, recipient1, recipient2 } = await loadFixture(
        deployContract
      );

      expect(await erc20Escrow.token1()).to.equal(await token1.getAddress());
      expect(await erc20Escrow.token2()).to.equal(await token2.getAddress());
      expect(await erc20Escrow.recipient1()).to.equal(recipient1.address);
      expect(await erc20Escrow.recipient2()).to.equal(recipient2.address);
      expect(await erc20Escrow.amount1()).to.equal(amount1);
      expect(await erc20Escrow.amount2()).to.equal(amount2);
    });
  });
});

import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

const EscrowModule = buildModule("EscrowModule", (m) => {
  const randomAddress = "0x8626f6940E2eb28930eFb4CeF49B2d1F2C9C1199";

  const lock = m.contract("ERC20Escrow", [randomAddress, randomAddress, 100, 100, randomAddress, randomAddress]);

  return { lock };
});

export default EscrowModule;

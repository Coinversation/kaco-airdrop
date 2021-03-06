// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// When running the script with `npx hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.
import { ethers } from "hardhat";
import hre from "hardhat";

const kaco = "0xf96429A7aE52dA7d07E60BE95A3ece8B042016fB";
const merkleRoot = "0xabd9fe4b4874c6846546c0cbbb959d1007a814fc8a04835284e403e49bb2942f";

const kaco_shiden = "0xb12c13e66ade1f72f71834f2fc5082db8c091358";
const merkleRoot20111207 = "0x5bc6cac604b108c960834821e143fa765f7852238aff5816137770813b4d54d3";

async function main() {
  // We get the contract to deploy
  const KacoAirDrop = await ethers.getContractFactory("KacoAirDropV2");
  const airDrop = await KacoAirDrop.deploy(kaco_shiden, merkleRoot20111207);

  await airDrop.deployed();

  console.log("airDrop deployed to:", airDrop.address);

  // const airdrop = "0x06351909a335fD23e2EFd93bEe7e2047332455fE";
  // await hre.run("verify:verify", {
  //   address: airdrop,
  //   contract: "contracts/KacoAirDrop.sol:KacoAirDrop",
  //   constructorArguments: [kaco, merkleRoot]
  // });
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});

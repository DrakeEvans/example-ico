// We require the Hardhat Runtime Environment explicitly here. This is optional 
// but useful for running the script in a standalone fashion through `node <script>`.
//
// When running the script with `hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.
import dotenv from 'dotenv';

dotenv.config();
const hre = require("hardhat");
const { BigNumber } = hre.ethers

async function main() {
  const [deployer] = await hre.ethers.getSigners();

  console.log(
    "Deploying contracts with the account:",
    deployer.address
  );
  
  const SpaceCoin = await hre.ethers.getContractFactory("SpaceCoin");
  const spaceCoin = await SpaceCoin.deploy(BigNumber.from(5).mul(BigNumber.from(10).pow(23)));
  await spaceCoin.deployed();
  // const addressesRaw = (await hre.getSigners()).map(({ address }: { [key: string]: any }) => address)
  
  const SpaceCoinIco = await hre.ethers.getContractFactory("SpaceCoinIco");
  const spaceCoinIco = await SpaceCoinIco.deploy(spaceCoin.address);
  await spaceCoinIco.deployed();
  await spaceCoinIco.updateWhitelist([process.env.WHITELIST], true);
  console.log("🚀 ~ file: deploy.ts ~ line 29 ~ main ~ process.env.WHITELIST", process.env.WHITELIST)
  
  console.log("spaceCoin deployed to:", spaceCoin.address);
  console.log("spaceCoinIco deployed to:", spaceCoinIco.address);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
  .then(() => process.exit(0))
  .catch(error => {
    console.error(error);
    process.exit(1);
  });

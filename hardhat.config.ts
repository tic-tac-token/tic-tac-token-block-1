import * as dotenv from "dotenv";

import { HardhatUserConfig, task } from "hardhat/config";
import "@nomiclabs/hardhat-etherscan";
import "@nomiclabs/hardhat-waffle";
import "@typechain/hardhat";
import "hardhat-gas-reporter";
import "solidity-coverage";

import { NFT, TicTacToken, Token } from "./typechain";

dotenv.config();

// This is a sample Hardhat task. To learn how to create your own go to
// https://hardhat.org/guides/create-task.html
task("accounts", "Prints the list of accounts", async (taskArgs, hre) => {
  const accounts = await hre.ethers.getSigners();

  for (const account of accounts) {
    console.log(account.address);
  }
});

interface Contracts {
  token: Token;
  nft: NFT;
  ttt: TicTacToken;
}

const deployContracts = async (ethers : any) : Promise<Contracts> => {
    const Token = await ethers.getContractFactory("Token");
    const token = await Token.deploy();
    await token.deployed();

    const NFT = await ethers.getContractFactory("NFT");
    const nft = await NFT.deploy();
    await nft.deployed();

    const TicTacToken = await ethers.getContractFactory("TicTacToken");
    const ttt = await TicTacToken.deploy(ethers.constants.AddressZero, token.address, nft.address);
    await ttt.deployed();

    await token.transferOwnership(ttt.address);
    await nft.transferOwnership(ttt.address);

    return { token, nft, ttt };
}

task("deploy", "Deploy contracts", async (taskArgs, hre) => {
  return await deployContracts(hre.ethers);
});

// You need to export an object to set up your config
// Go to https://hardhat.org/config/ to learn more

const config: HardhatUserConfig = {
  solidity: "0.8.10",
  networks: {
    ropsten: {
      url: process.env.ROPSTEN_URL || "",
      accounts:
        process.env.PRIVATE_KEY !== undefined ? [process.env.PRIVATE_KEY] : [],
    },
  },
  gasReporter: {
    enabled: process.env.REPORT_GAS !== undefined,
    currency: "USD",
  },
  etherscan: {
    apiKey: process.env.ETHERSCAN_API_KEY,
  },
};

export default config;

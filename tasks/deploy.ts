import "@nomiclabs/hardhat-ethers";

import { task } from "hardhat/config";
import { HardhatRuntimeEnvironment } from "hardhat/types";
import { NFT, TicTacToken, Token } from "../typechain";

interface Args {}

interface Contracts {
  token: Token;
  nft: NFT;
  ttt: TicTacToken;
}

export const deployContracts = async (args: Args, hre: HardhatRuntimeEnvironment) : Promise<Contracts> => {
    const { ethers } = hre;
    const [deployer] = await ethers.getSigners();

    console.log("Deploying Token...");
    const Token = await ethers.getContractFactory("Token");
    const token = await Token.deploy();
    await token.deployed();
    console.log("Token: ", token.address);

    console.log("Deploying NFT...");
    const NFT = await ethers.getContractFactory("NFT");
    const nft = await NFT.deploy();
    await nft.deployed();
    console.log("NFT: ", nft.address);

    console.log("Deploying Game...");
    const TicTacToken = await ethers.getContractFactory("TicTacToken");
    const ttt = await TicTacToken.deploy(deployer.address, token.address, nft.address);
    await ttt.deployed();
    console.log("Game: ", ttt.address);

    console.log("Updating owners...");
    await token.transferOwnership(ttt.address);
    await nft.transferOwnership(ttt.address);

    return { token, nft, ttt };
}

export default task("deploy", "Deploy contracts").setAction(deployContracts);

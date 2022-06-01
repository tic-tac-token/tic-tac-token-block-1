import { expect } from "chai";
import hre, { ethers } from "hardhat";
import { NFT, TicTacToken, Token } from "../typechain";


describe("Deployment", function () {

  it("Deploys the contracts", async function () {
    const { token, nft, ttt }  = await hre.run("deploy");


    expect(await token.name()).to.equal("Tic-Tac-Token");
    expect(await nft.name()).to.equal("Tic-Tac-Token NFT");
    expect(await ttt.token()).to.equal(token.address);
    expect(await ttt.nft()).to.equal(nft.address);
    expect(await token.owner()).to.equal(ttt.address);
    expect(await nft.owner()).to.equal(ttt.address);
  });


});

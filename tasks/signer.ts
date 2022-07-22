import '@nomiclabs/hardhat-ethers';

import { task } from 'hardhat/config';
import { HardhatRuntimeEnvironment } from 'hardhat/types';

interface Args {}

export async function signer(args: Args, hre: HardhatRuntimeEnvironment) {
  const { ethers } = hre;
  const [signer] = await ethers.getSigners();
  console.log("Signer address:", signer.address);
}

export default task("signer", "Prints active signer address").setAction(signer);

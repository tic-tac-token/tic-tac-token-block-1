import { Chain, chain } from 'wagmi';

const { polygonMumbai, hardhat } = chain;

export const config = {
  [polygonMumbai.id]: {
    game: "0x03789ab30651E7AABC6aCf07FeBdd30e66C941C2",
    token: "0x93A67aF92c7CB788037cf3Cf7A76c6C5a6e513f4",
    nft: "0x5F25FdC9720BbCB1174Ec78F41F2bFcF06E778c7",
  },
  [hardhat.id]: {
    game: "0x9fE46736679d2D9a65F0992F2272dE9f3c7fa6e0",
    token: "0x5FbDB2315678afecb367f032d93F642f64180aa3",
    nft: "0xe7f1725E7734CE288F8367e1Bb143E90bb3F0512",
  },
};

export const getConfig = (chain: Chain) => {
  return config[chain.id];
};

export default config[polygonMumbai.id];

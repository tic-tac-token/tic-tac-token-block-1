import { Chain, chain } from 'wagmi';

const { polygon, polygonMumbai, hardhat } = chain;

export const config = {
  [polygon.id]: {
    game: "0x1B2478C8297a95C3c3a5C7Ce173d7Edb5F10dc96",
    token: "0xB8EB2b0717B1c57536c5Fcb159dfA89Ab620000F",
    nft: "0xe1F7678A608E6c3Ec8FFA02F913bb92042d43BDf",
  },
  [polygonMumbai.id]: {
    game: "0x29bf075597526529789f3BCB2074aC2ADf602bDC",
    token: "0x048038894743d1ca62Ee0c04796c5FEEa8416322",
    nft: "0x9F2693425e7670027Ff65e0a1d08Fbcab3E05440",
  },
  [hardhat.id]: {
    game: "0x9fE46736679d2D9a65F0992F2272dE9f3c7fa6e0",
    token: "0x5FbDB2315678afecb367f032d93F642f64180aa3",
    nft: "0xe7f1725E7734CE288F8367e1Bb143E90bb3F0512",
  },
};

export const getConfig = (chain: Chain) => {
  if (config[chain.id]) {
    return config[chain.id];
  } else {
    return config[hardhat.id];
  }
};

export default config[polygonMumbai.id];

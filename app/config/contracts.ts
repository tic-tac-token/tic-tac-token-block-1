import { Chain, chain } from 'wagmi';

const { polygonMumbai, hardhat } = chain;

export const config = {
  [polygonMumbai.id]: {
    game: "0x8ffbFa177ae63760a77371dEE0fEcdA7A8c81aC2",
    token: "0xbDba800812D500dcB4cDD19C15712D68aC08406d",
    nft: "0x0239E20a0d606BD588B3E6cEbBdcEbbf1c0FF879",
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

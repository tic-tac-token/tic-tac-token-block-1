import { BigNumber, ethers } from 'ethers';
import { formatUnits } from 'ethers/lib/utils';
import {
    erc721ABI, useAccount, useBalance, useContractRead, useContractWrite, useNetwork
} from 'wagmi';

import { getConfig } from '../config/contracts';

const formatSymbol = (number: BigNumber) => {
  if (number.eq(BigNumber.from(1))) {
    return "X";
  } else if (number.eq(BigNumber.from(2))) {
    return "O";
  } else {
    return " ";
  }
};

export function useBoard(gameId: number) {
  const { activeChain } = useNetwork();
  if (!activeChain) return {};
  const contracts = getConfig(activeChain);
  const {
    data: board,
    isError,
    isLoading,
    error,
  } = useContractRead(
    {
      addressOrName: contracts.game,
      contractInterface: [
        "function getBoard(uint256 gameId) external view returns (uint256[9] memory)",
      ],
    },
    "getBoard",
    { args: [gameId], watch: true }
  );

  const formattedBoard = board?.map(formatSymbol);

  return { formattedBoard, board, isError, isLoading, error };
}

export function useGame(gameId: number) {
  const { activeChain } = useNetwork();
  if (!activeChain) return {};
  const contracts = getConfig(activeChain);
  const {
    data: game,
    isError,
    isLoading,
    error,
  } = useContractRead(
    {
      addressOrName: contracts.game,
      contractInterface: [
        "function games(uint256) external view returns (tuple(address,address,uint256))",
      ],
    },
    "games",
    { args: [gameId], watch: true }
  );
  console.log("game: ", game);
  const [playerX, playerO] = game || ["", ""];

  return { game, playerX, playerO, isError, isLoading, error };
}

export function useGamesByPlayer() {
  const { data: account } = useAccount();
  const { activeChain } = useNetwork();
  if (!activeChain) return {};
  const contracts = getConfig(activeChain);
  const {
    data: games,
    isError,
    isLoading,
    error,
  } = useContractRead(
    {
      addressOrName: contracts.game,
      contractInterface: [
        "function gamesByPlayer(address) external view returns (uint256[] memory)",
      ],
    },
    "gamesByPlayer",
    { args: [account?.address], watch: true }
  );

  return { games, isError, isLoading, error };
}

export function useTTTBalance() {
  const { data: account } = useAccount();
  const { activeChain } = useNetwork();
  if (!activeChain) return {};
  const contracts = getConfig(activeChain);
  const {
    data: balance,
    isError,
    isLoading,
    error,
  } = useBalance({
    addressOrName: account?.address,
    token: contracts.token,
  });

  return { balance, isError, isLoading, error };
}

export function useNFTBalance() {
  const { data: account } = useAccount();
  const { activeChain } = useNetwork();
  if (!activeChain) return {};
  const contracts = getConfig(activeChain);
  const { data, isError, isLoading, error } = useContractRead(
    {
      addressOrName: contracts.nft,
      contractInterface: erc721ABI,
    },
    "balanceOf",
    { args: [account?.address], watch: true }
  );

  const balance = {
    formatted: formatUnits(data || 0, "wei"),
    symbol: "NFT",
  };

  return { balance, isError, isLoading, error };
}

export function useMarkSpace() {
  const { activeChain } = useNetwork();
  if (!activeChain) return {};
  const contracts = getConfig(activeChain);
  const {
    data,
    write: markSpace,
    isError,
    isLoading,
    error,
    status,
  } = useContractWrite(
    {
      addressOrName: contracts.game,
      contractInterface: [
        "function markSpace(uint256 gameId, uint256 space) external",
      ],
    },
    "markSpace"
  );
  return { data, markSpace, isError, isLoading, error, status };
}

export function useNewGame() {
  const { activeChain } = useNetwork();
  if (!activeChain) return {};
  const contracts = getConfig(activeChain);
  const {
    data,
    write: newGame,
    isError,
    isLoading,
    error,
  } = useContractWrite(
    {
      addressOrName: contracts.game,
      contractInterface: [
        "function newGame(address playerX, address playerO) external",
      ],
    },
    "newGame"
  );
  return { data, newGame, isError, isLoading, error };
}

import { etherscanBlockExplorers } from 'wagmi';

import { useGame } from '../hooks/contracts';

interface Props {
  gameId: number;
}

const formatAddress = (address?: string) => {
  if (address) {
    return `${address.slice(0, 8)}...${address.slice(-6)}`;
  } else {
    return "";
  }
};

const explorerLink = (address: string) => {
  return `${etherscanBlockExplorers.polygonMumbai.url}/address/${address}`;
};

const Players = ({ gameId }: Props) => {
  const { playerX, playerO } = useGame(gameId);

  return (
    <div className="text-lg my-4">
      <div>
        <span className="font-bold">Player X:</span>{" "}
        <a href={explorerLink(playerX)}>
          <pre className="inline">{formatAddress(playerX)}</pre>
        </a>
      </div>
      <div>
        <span className="font-bold">Player O:</span>{" "}
        <a href={explorerLink(playerO)}>
          <pre className="inline">{formatAddress(playerO)}</pre>
        </a>
      </div>
    </div>
  );
};

export default Players;

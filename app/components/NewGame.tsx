import { useRouter } from 'next/router';
import React, { useState } from 'react';
import { useAccount, useWaitForTransaction } from 'wagmi';

import { useNewGame } from '../hooks/contracts';

const NewGame = () => {
  const router = useRouter();
  const { data: account } = useAccount();
  const { data: newGameTx, newGame, error } = useNewGame();
  const { data, isSuccess, isLoading } = useWaitForTransaction({
    hash: newGameTx?.hash,
  });
  const [opponentAddress, setOpponentAddress] = useState<string>();

  const onOpponentChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    setOpponentAddress(e.target.value);
  };

  return (
    <div>
      <input
        type="text"
        className="px-2 py-4 border border-gray-300"
        placeholder="Opponent"
        onChange={onOpponentChange}
      />
      <button
        className="px-2 py-4 bg-purple-50 mx-4 rounded shadow-md"
        onClick={() =>
          newGame &&
          newGame({
            args: [account?.address, opponentAddress],
          })
        }
      >
        New game
      </button>
      {isLoading && <p>Creating new game...</p>}
      {isSuccess && <p>Game created!</p>}
      {error && error.message}
    </div>
  );
};

export default NewGame;

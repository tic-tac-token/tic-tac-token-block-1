import { BigNumber } from 'ethers';
import { formatUnits } from 'ethers/lib/utils';
import Link from 'next/link';

import { useGamesByPlayer } from '../hooks/contracts';

type GameData = BigNumber[] | undefined;

const ActiveGames = () => {
  const { games: gameData } = useGamesByPlayer();
  const games = gameData as GameData;
  return (
    <div className="mb-4">
      {games &&
        games.map((game) => {
          const gameId = formatUnits(game, "wei");
          return (
            <div key={gameId} className="my-2">
              <Link passHref href={`/games/${gameId}`}>
                <a className="text-xl text-purple-600 underline hover:text-purple-800">
                  Game #{gameId}
                </a>
              </Link>
            </div>
          );
        })}
    </div>
  );
};

export default ActiveGames;

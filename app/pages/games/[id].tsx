import type { NextPage } from "next";
import { useRouter } from 'next/router';
import { NextRequest } from 'next/server';

import Board from '../../components/Board';
import Players from '../../components/Players';
import FullPage from '../../layouts/FullPage';

const Game: NextPage = () => {
  const router = useRouter();
  const { id } = router.query;
  const gameId = parseInt((id || 0).toString());

  return (
    <FullPage>
      {id && (
        <div>
          <Board gameId={gameId} />
          <Players gameId={gameId} />
        </div>
      )}
    </FullPage>
  );
};

export default Game;

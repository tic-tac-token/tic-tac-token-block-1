import type { NextPage } from "next";
import ActiveGames from '../components/ActiveGames';
import Balance from '../components/Balance';
import Board from '../components/Board';
import NewGame from '../components/NewGame';
import Players from '../components/Players';
import FullPage from '../layouts/FullPage';

const Home: NextPage = () => {
  return (
    <FullPage>
      <div>
        <Balance />
        <ActiveGames />
        <NewGame />
      </div>
    </FullPage>
  );
};

export default Home;

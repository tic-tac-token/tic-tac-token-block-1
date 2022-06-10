import type { NextPage } from 'next';
import Account from '../components/Account';
import Balance from '../components/Balance';
import Board from '../components/Board';
import NFTBalance from '../components/NFTBalance';
import TokenData from '../components/TokenData';
import FullPage from '../layouts/FullPage';

const Home: NextPage = () => {
  return <FullPage>
    <div>
      <Board gameId={1} />
    </div>
  </FullPage>
};

export default Home;

import Head from 'next/head';
import { ConnectButton } from '@rainbow-me/rainbowkit';

interface Props {
  children: React.ReactNode;
}

const FullPage = ({ children }: Props) => {
  return (
    <div>
      <Head>
        <title>Tic Tac Token</title>
      </Head>

      <main className="px-16 py-28 text-center">
        <div className="fixed top-12 right-12"><ConnectButton /></div>
        <div>
          <h1 className="text-purple-700 font-display font-bold text-6xl mb-4">Tic Tac Token</h1>
          <div>{children}</div>
        </div>
      </main>
    </div>
  );
};

export default FullPage;

import { useAccount, useBalance } from 'wagmi';

import { useNFTBalance, useTTTBalance } from '../hooks/contracts';

const Balance = () => {
  const {
    balance: tttBalance,
    isError: tttError,
    isLoading: tttLoading,
  } = useTTTBalance();
  const {
    balance: nftBalance,
    isError: nftError,
    isLoading: nftLoading,
  } = useNFTBalance();

  if (tttLoading || nftLoading) return <div>Loading...</div>;
  if (tttError || nftError) return <div>Error</div>;
  return (
    <div>
      Balances:
      <p>
        {tttBalance?.formatted} {tttBalance?.symbol}
      </p>
      <p>
        {nftBalance?.formatted} {nftBalance?.symbol}
      </p>
    </div>
  );
};

export default Balance;

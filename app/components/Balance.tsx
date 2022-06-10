import { useAccount, useBalance } from 'wagmi';

const Balance = () => {
    const { data: accountData } = useAccount();
    const { data: balanceData, isError, isLoading } = useBalance({
        addressOrName: accountData?.address,
        token: "0xEb39De8f589Ea8CE9D06fC938353892E34054804"
    });

    if (isLoading) return <div>Loading...</div>
    if (isError) return <div>Error</div>
    return <div>Balance: {balanceData?.formatted} {balanceData?.symbol}</div>
}

export default Balance;

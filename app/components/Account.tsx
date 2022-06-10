import { useAccount } from 'wagmi';

const Account = () => {
    const { data, isError, isLoading } = useAccount();

    if (isLoading) return <div>Loading...</div>
    if (isError) return <div>Error</div>
    return <div>Account: {data?.address}</div>
}

export default Account;

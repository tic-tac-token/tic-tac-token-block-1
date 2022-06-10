import { ethers } from 'ethers';
import { formatUnits } from 'ethers/lib/utils';
import { useContractRead, useAccount, erc721ABI } from 'wagmi';

const NFTBalance = () => {
    const { data: accountData } = useAccount();
    const { data: balanceData, isError, isLoading } = useContractRead({
        addressOrName: "0x21100c01a1fabd54fFE428478f63548619992961",
        contractInterface: new ethers.utils.Interface([
            "function balanceOf(address) external view returns (uint256)"
        ])
    },
    'balanceOf',
    { args: accountData?.address }
    );

    if (isLoading) return <div>Loading...</div>
    if (isError) return <div>Error</div>
    return <div>Balance: {formatUnits(balanceData || "0", "wei")}</div>
}

export default NFTBalance;

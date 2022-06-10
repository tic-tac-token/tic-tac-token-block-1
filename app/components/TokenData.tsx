import { Result } from 'ethers/lib/utils';
import { useContractRead, erc721ABI } from 'wagmi';

const decodeURI = (dataURI : Result | undefined) => {
    if (!dataURI) return {};
    const [_mimeType, dataString] = dataURI.split(';');
    const [_encoding, data] = dataString.split(',');
    const decoded = Buffer.from(data, 'base64');
    return JSON.parse(decoded.toString());
}

const NFTBalance = () => {
    const { data: tokenURI, isError, isLoading } = useContractRead({
        addressOrName: "0x21100c01a1fabd54fFE428478f63548619992961",
        contractInterface: erc721ABI
    },
    'tokenURI',
    { args: 1 }
    );

    if (isLoading) return <div>Loading...</div>
    if (isError) return <div>Error</div>
    const metadata = decodeURI(tokenURI);
    return <div>{ JSON.stringify(metadata) }</div>
}

export default NFTBalance;

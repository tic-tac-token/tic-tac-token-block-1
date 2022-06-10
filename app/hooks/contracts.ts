import { useContractRead } from "wagmi";
import { BigNumber, ethers } from "ethers";
import contracts from "../config/contracts";

const formatSymbol = (number : BigNumber) => {
    if (number.eq(BigNumber.from(1))) {
        return "X";
    } else if (number.eq(BigNumber.from(2))) {
        return "O";
    } else {
        return "_";
    }
}

export function useBoard(gameId : number) {
    const { data: board, isError, isLoading, error } = useContractRead({
        addressOrName: contracts.game,
        contractInterface: new ethers.utils.Interface([
            "function getBoard(uint256) external view returns (uint256[9])"
        ]),
    },
    'getBoard',
    { args: gameId }
    );

    const formattedBoard = board?.map(formatSymbol);

    return { formattedBoard, board, isError, isLoading, error };
}

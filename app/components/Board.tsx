import { useBlockNumber, useWaitForTransaction } from 'wagmi';

import { useBoard, useMarkSpace, useNewGame } from '../hooks/contracts';

interface Props {
  gameId: number;
}

const Board = ({ gameId }: Props) => {
  const { formattedBoard } = useBoard(gameId);
  const {
    data: markSpaceTx,
    markSpace,
    error: markSpaceError,
    status,
  } = useMarkSpace();
  const { data, isSuccess, isLoading } = useWaitForTransaction({
    hash: markSpaceTx?.hash,
  });
  const { data: block } = useBlockNumber();

  return (
    <div className="container w-3/4 mx-auto">
      <h2 className="mb-4 text-2xl font-bold">Game #{gameId}</h2>
      <div className="grid items-center grid-cols-3 gap-6 justify-items-center">
        {formattedBoard &&
          formattedBoard.map((space, idx) => (
            <div
              key={idx}
              className="flex items-center justify-center w-full rounded-lg shadow-lg bg-purple-50 aspect-square hover:cursor-pointer hover:bg-purple-200"
              onClick={() => markSpace && markSpace({ args: [gameId, idx] })}
            >
              <span className="font-extrabold text-purple-700 text-8xl">
                {space}
              </span>
            </div>
          ))}
      </div>
      <div>Block: {block}</div>
      {isLoading && <p>Marking space...</p>}
      {isSuccess && <p>Marked!</p>}
      {markSpaceError && <p>{markSpaceError.toString()}</p>}
    </div>
  );
};

export default Board;

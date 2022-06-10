import { useBoard } from "../hooks/contracts";

interface Props {
    gameId: number;
}

const Board = ({ gameId } : Props) => {
    const { formattedBoard } = useBoard(gameId);

    return (
      <div>
        <h2>Game #{gameId}</h2>
        <div style={{ display: 'grid', justifyItems: 'center', alignItems: 'center', gridTemplateColumns: 'repeat(3, 1fr)', gridGap: '3vw', margin: 'auto', width: 'auto' }}>
        { formattedBoard && formattedBoard.map(space => <div style={{ display: 'flex', justifyContent: 'center', alignItems: 'center', width: '20vw', height: '20vw', backgroundColor: "#999" }}><span className="text-4xl">{ space }</span></div>)}

        </div>
      </div>
    );
}

export default Board;

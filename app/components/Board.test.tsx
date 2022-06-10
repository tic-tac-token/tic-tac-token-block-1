import { render, screen } from '@testing-library/react'
import Board from './Board'
import { useContractRead } from 'wagmi';

jest.mock('wagmi');
const mockUseContractRead = useContractRead as jest.Mock<any>

mockUseContractRead.mockReturnValue({ data: [], isError: false, isLoading: false});

describe('Board', () => {
  it('shows the game ID', () => {
    render(<Board gameId={1} />)

    const board  = screen.getByText('Game #1');

    expect(board).toBeInTheDocument();
  });
})

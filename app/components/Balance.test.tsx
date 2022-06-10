import { render, screen } from '@testing-library/react'
import Balance from './Balance'
import { useAccount, useBalance } from 'wagmi';

jest.mock('wagmi');
const useBalanceMock = useBalance as jest.Mock<any>
const useAccountMock = useAccount as jest.Mock<any>
useAccountMock.mockReturnValue({
    data: { address: "0x1" }
});

describe('Balance', () => {
  it('shows a loading message when loading', () => {
    useBalanceMock.mockReturnValue({ data: undefined, isError: false, isLoading: true });
    render(<Balance />)

    const loading = screen.getByText('Loading...');

    expect(loading).toBeInTheDocument();
  });

  it('shows an error message on error', () => {
    useBalanceMock.mockReturnValue({ data: undefined, isError: true, isLoading: false});
    render(<Balance />)

    const error = screen.getByText('Error');

    expect(error).toBeInTheDocument();
  })

  it('shows balance data when loaded', () => {
    useBalanceMock.mockReturnValue({ data: {formatted: "100", symbol: "TTT"}, isError: false, isLoading: false});
    render(<Balance />)

    const balance = screen.getByText('Balance: 100 TTT');

    expect(balance).toBeInTheDocument();
  })
})

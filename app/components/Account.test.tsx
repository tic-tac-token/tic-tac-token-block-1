import { render, screen } from '@testing-library/react'
import Account from './Account'
import { useAccount } from 'wagmi';

jest.mock('wagmi');
const useAccountMock = useAccount as jest.Mock<any>

describe('Account', () => {
  it('shows a loading message when loading', () => {
    useAccountMock.mockReturnValue({ data: undefined, isError: false, isLoading: true });
    render(<Account />)

    const loading = screen.getByText('Loading...');

    expect(loading).toBeInTheDocument();
  });

  it('shows an error message on error', () => {
    useAccountMock.mockReturnValue({ data: undefined, isError: true, isLoading: false});
    render(<Account />)

    const error = screen.getByText('Error');

    expect(error).toBeInTheDocument();
  })

  it('shows address when loaded', () => {
    useAccountMock.mockReturnValue({ data: {address: "0x1"}, isError: false, isLoading: false});
    render(<Account />)

    const account = screen.getByText('Account: 0x1');

    expect(account).toBeInTheDocument();
  })
})

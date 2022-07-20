// SPDX-License-Identifier: Apache-2.0
pragma solidity 0.8.10;

import "../../lib/openzeppelin-contracts/contracts/token/ERC721/IERC721.sol";

interface INFT is IERC721 {
    function mint(address to, uint256 tokenId) external;
}

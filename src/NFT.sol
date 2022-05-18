
// SPDX-License-Identifier: Apache-2.0
pragma solidity 0.8.10;

import "openzeppelin-contracts/contracts/token/ERC721/ERC721.sol";
import "openzeppelin-contracts/contracts/access/Ownable.sol";
import "openzeppelin-contracts/contracts/utils/Strings.sol";
import "openzeppelin-contracts/contracts/utils/Base64.sol";

contract NFT is ERC721, Ownable {
    using Strings for uint256;

    constructor() ERC721("Tic-Tac-Token NFT", "NFT") {}

    function mint(address to, uint256 tokenId) public onlyOwner {
      _safeMint(to, tokenId);
    }

    function tokenJSON(uint256 tokenId) public view returns (string memory) {
      return string(abi.encodePacked(
        '{"name":"',
        _tokenName(tokenId),
        '","description":"Tic-Tac-Token","image":"',
        '',
        '"}'
      ));
    }

    function tokenURI(uint256 tokenId) public override view returns (string memory) {
      return string(abi.encodePacked(
        "data:application/json;base64,",
        Base64.encode(abi.encodePacked(tokenJSON(tokenId)))
        )
      );
    }

    function _tokenName(uint256 tokenId) internal view returns (string memory) {
      return string(abi.encodePacked("Game #", _gameId(tokenId)));
    }

    function _gameId(uint256 tokenId) public pure returns (string memory) {
      uint256 gameId;
      if (tokenId % 2 == 0) {
        gameId = tokenId / 2;
      } else {
        gameId =  (tokenId + 1) / 2;
      }
      return gameId.toString();
    }
}

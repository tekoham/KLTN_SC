//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "../interface/ICollection.sol";

contract Collection is ERC721URIStorage, Ownable, ICollection {
    mapping(uint256 => Collectible) collectible;
    using Counters for Counters.Counter;
    Counters.Counter tokenIds;

    constructor(string memory name, string memory symbol)
        ERC721(name, symbol)
    {}

    function mint(
        address _to,
        string memory _name,
        string memory _description,
        string memory _category,
        string memory _tokenURI
    ) public override returns (uint256) {
        tokenIds.increment();
        collectible[tokenIds.current()].name = _name;
        collectible[tokenIds.current()].description = _description;
        collectible[tokenIds.current()].category = _category;
        _safeMint(_to, tokenIds.current());
        _setTokenURI(tokenIds.current(), _tokenURI);
        return tokenIds.current();
    }
}

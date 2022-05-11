//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "../interface/ICollection.sol";
import "../interface/IFixedPrice.sol";
import "../interface/IAuction.sol";

contract Collection is ERC721URIStorage, Ownable, ICollection {
    mapping(uint256 => Collectible) collectible;
    using Counters for Counters.Counter;
    Counters.Counter tokenIds;
    address public sellContractAddress;
    address public auctionContractAddress;
    address private WETH = 0xB4FBF271143F4FBf7B91A5ded31805e42b2208d6;
    
    constructor(string memory name, string memory symbol, address _sellContractAddress, address _auctionContractAddress)
        ERC721(name, symbol)
    {
        sellContractAddress = _sellContractAddress;
        auctionContractAddress = _auctionContractAddress;
        setApprovalForAll(_sellContractAddress, true);
        setApprovalForAll(_auctionContractAddress, true);
    }

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

    function mintAndListForSale(
        address _to,
        string memory _name,
        string memory _description,
        string memory _category,
        string memory _tokenURI,
        uint256 _price
    ) public override returns (uint256) {
        tokenIds.increment();
        collectible[tokenIds.current()].name = _name;
        collectible[tokenIds.current()].description = _description;
        collectible[tokenIds.current()].category = _category;
        _safeMint(_to, tokenIds.current());
        _setTokenURI(tokenIds.current(), _tokenURI);
        IFixedPrice(sellContractAddress).sell(address(this), tokenIds.current(), _price);
        return tokenIds.current();
    }

    function mintAndListOnAuction(
        address _to,
        string memory _name,
        string memory _description,
        string memory _category,
        string memory _tokenURI,
        uint256 _startBid
    ) public override returns (uint256) {
        tokenIds.increment();
        collectible[tokenIds.current()].name = _name;
        collectible[tokenIds.current()].description = _description;
        collectible[tokenIds.current()].category = _category;
        _safeMint(_to, tokenIds.current());
        _setTokenURI(tokenIds.current(), _tokenURI);
        IAuction(auctionContractAddress).start(address(this), tokenIds.current(), WETH, _startBid);
        return tokenIds.current();
    }
}

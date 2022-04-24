//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "../interface/ICollectionFactory.sol";
import "./Collection.sol";

contract CollectionFactory is ICollectionFactory {
    bool internal processing = false;
    mapping(uint256 => address) collectionAddresses;
    using Counters for Counters.Counter;
    Counters.Counter collectionIds;
    address sellContractAddress;
    address auctionContractAddress;

    constructor(address _sellContractAddress, address _auctionContractAddress) {
        sellContractAddress = _sellContractAddress;
        auctionContractAddress = _auctionContractAddress;
    }

    function createCollection(string memory _name, string memory _symbol)
        external
        override
        onlyNotProcessing
        returns (address)
    {
        collectionIds.increment();
        Collection collection = new Collection(_name, _symbol, sellContractAddress, auctionContractAddress);
        address collectionAddress = address(collection);
        collectionAddresses[collectionIds.current()] = collectionAddress;
        emit CollectionCreated(
            collectionIds.current(),
            collectionAddress,
            msg.sender
        );

        return collectionAddress;
    }

    modifier onlyNotProcessing() {
        require(!processing, "Invalid processing");
        processing = true;
        _;
        processing = false;
    }
}

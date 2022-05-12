//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

interface ICollectionFactory {
    /// @notice Class of all initial collectible creation parameters.
    event CollectionCreated(
        uint256 indexed id,
        address indexed collectionAddress,
        address indexed creator
    );

    function createCollection(string memory _name, string memory _symbol)
        external
        returns (address);

    function setSellContractAddress (address _sellContractAddress) external;

    function setAuctionContractAddress (address _auctionContractAddress) external;
}

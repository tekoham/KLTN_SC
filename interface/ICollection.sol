//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

interface ICollection {
    /// @notice Class of all initial collectible creation parameters.
    struct Collectible {
        string name;
        string description;
        string category;
    }

    /**
     * Mint NFT
     */
    function mint(
        address _to,
        string memory _name,
        string memory _description,
        string memory _category,
        string memory _tokenURI
    ) external returns (uint256);

    function mintAndListForSale(
        address _to,
        string memory _name,
        string memory _description,
        string memory _category,
        string memory _tokenURI,
        uint256 _price
    ) external returns (uint256);

    function mintAndListOnAuction(
        address _to,
        string memory _name,
        string memory _description,
        string memory _category,
        string memory _tokenURI,
        uint256 _startBid
    ) external returns (uint256);
}

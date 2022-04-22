// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract FixedPrice is Ownable {
    constructor() {}
    // ------- structs ------- //
    struct FixedPrice {
        uint256 price;
        address creator;
    }
    // ------- var ------- //
    address constant public EMPTY_ADDRESS = 0x0000000000000000000000000000000000000000;
    // ------- mapping ------- //
    // mapping contract sale and id to sell data;
    mapping(bytes32 => FixedPrice) private mapTokenToFixedPrice;

    // Sell an item at fixed price
    function sell(address _contract_sale, uint256 _token_id, uint256 _price) external {
        bytes32 hashed = sha256(abi.encodePacked(_contract_sale, _token_id));
        IERC721 contractSale = IERC721(_contract_sale);
        // must be owner
        require(contractSale.ownerOf(_token_id) == msg.sender, "NOT_OWNED");
        // transfer to sale contract
        contractSale.transferFrom(msg.sender, address(this), _token_id);
        // write data to map
        mapTokenToFixedPrice[hashed] = FixedPrice(_price, msg.sender);
    }

    // Buy
    function buy(address _contract_sale, uint256 _token_id) external payable {
        // get data out
        IERC721 contractSale = IERC721(_contract_sale);
        bytes32 hashedFixedPrice = sha256(abi.encodePacked(_contract_sale, _token_id));
        uint256 itemPrice = mapTokenToFixedPrice[hashedFixedPrice].price;
        address creator = mapTokenToFixedPrice[hashedFixedPrice].creator;
        require(creator != EMPTY_ADDRESS, "NOT_EXISTED");
        require(msg.value >= itemPrice, "NOT_ENOUGH_ETHER");
        // Return any extra
        if(msg.value > itemPrice) {
            (bool _sent, ) = msg.sender.call{value: msg.value - itemPrice}("");
            require(_sent, "FAILED_ETH_TRANSFER");
        }

        contractSale.transferFrom(address(this), msg.sender, _token_id);

        (bool sent, ) = creator.call{value: itemPrice}("");
        require(sent, "FAILED_ETH_TRANSFER");

    }

    // return sell info
    function sellInfo(address _contract_sale, uint256 _token_id) external view returns(
        uint256 price,
        address creator
    ) {
        bytes32 hashed = sha256(abi.encodePacked(_contract_sale, _token_id));
        price = mapTokenToFixedPrice[hashed].price;
        creator = mapTokenToFixedPrice[hashed].creator;
    }

    // Cancel sell
    function cancelSell(address _contract_sale, uint256 _token_id) external {
        bytes32 hashedFixedPrice = sha256(abi.encodePacked(_contract_sale, _token_id));
        IERC721 contractSale = IERC721(_contract_sale);
        require(mapTokenToFixedPrice[hashedFixedPrice].creator == msg.sender, "NOT_CREATOR");
        contractSale.transferFrom(address(this), mapTokenToFixedPrice[hashedFixedPrice].creator, _token_id);
    }
}
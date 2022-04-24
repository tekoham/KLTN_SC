//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

interface IAuction{
    /// @notice Class of all initial collectible creation parameters.
    struct FixedPriceItem {
        uint256 price;
        address creator;
    }

    /**
     * Owner calls to sellcontract
     */
    function start(address _contract_sale, uint256 _token_id, address _coin_buy, uint256 _start_price) external;

    /**
     * Owner calls to sellcontract
     */
    function bid(address _contract_sale, uint256 _token_id, uint256 amount) external;

    function auctionInfo(address _contract_sale, uint256 _token_id) external view returns(
        uint256 start_price,
        address highest_bidder,
        address coin_buy,
        address creator,
        bool ended
    );

    function biddedBalance(address _contract_sale, uint256 _token_id, address _bidder) external view returns(uint256 bidded);

    function withdraw(address _contract_sale, uint256 _token_id) external;

    function finish(address _contract_sale, uint256 _token_id) external;
}

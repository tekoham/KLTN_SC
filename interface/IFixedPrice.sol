//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

interface IFixedPrice {
    /// @notice Class of all initial collectible creation parameters.
    struct FixedPriceItem {
        uint256 price;
        address creator;
    }

    /**
     * Owner calls to sellcontract
     */
    function sell(address _contract_sale, uint256 _token_id, uint256 _price) external;

    /**
     * Owner calls to sellcontract
     */
    function buy(address _contract_sale, uint256 _token_id, address coin_buy, uint256 amount) external;

    function sellInfo(address _contract_sale, uint256 _token_id) external view returns(
        uint256 price,
        address creator
    );

    function cancelSell(address _contract_sale, uint256 _token_id) external;

}

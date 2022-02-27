pragma solidity ^0.8.10;

interface IChicken {
    // Get token ID
    function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);

    // Get balance of token ID
    function balanceOf(address owner) external view returns (uint256 balance);
}
pragma solidity ^0.8.10;

// Import modules
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./IChicken.sol";

// Define contract
contract ChickenToken is ERC20, Ownable {
    // Price token
    uint256 public constant tokenPrice = 0.001 ether;
    // Token per NFT
    uint256 public constant tokensPerNFT = 10 * 10**18;
    // Max total supply is 10.000 tokens
    uint256 public constant maxTotalSupply = 10000 * 10**18;
    // Chicken NFT Contract instance
    IChicken ChickenNFT;
    // Mapping to keep track of which tokenIds have claimed
    mapping(uint256 => bool) public tokenIdsClaimed;

    constructor(address _chickenNFTContract) ERC20("Chicken Token", "CHEN") {
        ChickenNFT = IChicken(_chickenNFTContract);
    }

    /**
       * @dev Mints `amount` number of CryptoDevTokens
       * Requirements:
       * - `msg.value` should be equal or greater than the tokenPrice * amount
    */
    function mint(uint256 amount) public payable {
        uint256 _requireAmount = tokenPrice * amount;
        // the value of ether that should be equal or greater than tokenPrice * amount;
        // Check this condition
        require(msg.value >= _requireAmount, "Ether sent is incorrect");

        uint256 amountWithDecimals = amount * 10**18;
        // total tokens + amount <= 10000, otherwise revert the transaction
        require(
            (totalSupply() + amountWithDecimals) <= maxTotalSupply, 
            "Exceeds the max total supply available."
        );
        // call the internal function from Openzeppelin's ERC20 contract
        _mint(msg.sender, amountWithDecimals);
    }

    /**
       * @dev Mints tokens based on the number of NFT's held by the sender
       * Requirements:
       * balance of Crypto Dev NFT's owned by the sender should be greater than 0
       * Tokens should have not been claimed for all the NFTs owned by the sender
    */
    function claim() public {
        address sender = msg.sender;
        // Get number of Chicken NFT's held
        uint256 balance = ChickenNFT.balanceOf(sender);
        // If the balance is zero, revert the transaction
        require(balance > 0, "You dont own any Chicken NFT's");
        // amount keeps track of number of unclaimed tokenIds
        uint256 _amount = 0;
        // loop over the balance and get the token ID owned by `sender` at a given `index` of its token list.
        for (uint256 i = 0; i < balance; i++) {
            uint256 tokenId = ChickenNFT.tokenOfOwnerByIndex(sender, i);
            // if the tokenId has not been claimed, increase the amount
            if (!tokenIdsClaimed[tokenId]) {
                _amount += 1;
                tokenIdsClaimed[tokenId] = true;
            }
        }
        // If all the token Ids have been claimed, revert the transaction;
        require(_amount > 0, "You have already claimed all the tokens");
        // call the internal function from Openzeppelin's ERC20 contract
        // Mint (amount * 10) tokens for each NFT
        _mint(msg.sender, _amount * tokensPerNFT);
    }

    // Function to receive Ether. msg.data must be empty
    receive() external payable {}

    // Fallback function is called when msg.data is not empty
    fallback() external payable {}
}
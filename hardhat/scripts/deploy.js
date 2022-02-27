const { ethers } = require("hardhat");
require("dotenv").config({ path: ".env" });
const { CHICKEN_NFT_CONTRACT_ADDRESS } = require("../constants");

async function main() {
    // NFT Contract Address
    const chickenNFTContract = CHICKEN_NFT_CONTRACT_ADDRESS;

    /*
        A ContractFactory in ethers.js is an abstraction used to deploy new smart contracts,
        so cryptoDevsTokenContract here is a factory for instances of our CryptoDevToken contract.
    */
    const chickenTokenContract = await ethers.getContractFactory(
        "ChickenToken"
    );

    // Deploy the contract
    const deployedContract = await chickenTokenContract.deploy(
        chickenNFTContract
    );

    // print the address of the deployed contract
    console.log(
        "Chicken Token Contract Address:",
        deployedContract.address
    );
}

// Call the main function and catch if there is any error
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
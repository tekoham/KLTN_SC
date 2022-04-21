const hre = require("hardhat");
const { ethers, upgrades } = hre;
const { getContracts, saveContract } = require('./utils');

async function main() {
  const network = hre.network.name;
  const contracts = await getContracts(network)[network];

  const Collection = await hre.ethers.getContractFactory("Collection");

  const collection = await Collection.attach('0x84c24AA93f6c3d73995233684D24c9122A6c0aDe');
  await collection.deployed();

  console.log("Collection deployed to:", collection.address);

  await hre.run("verify:verify", {
      address: collection.address,
      constructorArguments: [
        '"TestCollection"',
        '"TC"'
      ],
  });

}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });

const hre = require("hardhat");
const { ethers, upgrades } = hre;
const { getContracts, saveContract } = require('./utils');

async function main() {
  const network = hre.network.name;
  const contracts = await getContracts(network)[network];

  const CollectionFactory = await hre.ethers.getContractFactory("CollectionFactory");
  // const collectionFactory = await CollectionFactory.deploy();
  const collectionFactory = await CollectionFactory.attach(contracts.collectionFactory);
  await collectionFactory.deployed();
  await saveContract(network, 'collectionFactory', collectionFactory.address);
  console.log("Collection Factory deployed to:", collectionFactory.address);

  await hre.run("verify:verify", {
      address: collectionFactory.address,
      constructorArguments: [
      ],
  });

  console.log("Completed !");

}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });

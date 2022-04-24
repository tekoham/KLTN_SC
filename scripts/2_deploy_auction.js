const hre = require('hardhat')
const { ethers, upgrades } = hre
const { getContracts, saveContract } = require('./utils')

async function main() {
  const network = hre.network.name
  const contracts = await getContracts(network)[network]

  const Auction = await hre.ethers.getContractFactory('Auctions')
  const auction = await Auction.deploy()
  // const auction = await Auction.attach(
  //   contracts.auction
  // )
  await auction.deployed()
  await saveContract(network, 'auction', auction.address)
  console.log('Auction deployed to:', auction.address)

  await hre.run('verify:verify', {
    address: auction.address,
    constructorArguments: [],
  })

  console.log('Completed !')
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error)
    process.exit(1)
  })

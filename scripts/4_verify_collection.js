const hre = require('hardhat')
const { ethers, upgrades } = hre
const { getContracts, saveContract } = require('./utils')

async function main() {
  const network = hre.network.name
  const contracts = await getContracts(network)[network]

  const Collection = await hre.ethers.getContractFactory('Collection')

  const collection = await Collection.attach(
    '0x5DFDfD1CE60C660AAfC545403208e5EFe5649c28'
  )
  await collection.deployed()

  console.log('Collection deployed to:', collection.address)

  await hre.run('verify:verify', {
    address: collection.address,
    constructorArguments: [
      'Game3',
      'G',
      contracts.fixedPrice,
      contracts.auction,
    ],
  })
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error)
    process.exit(1)
  })

const hre = require('hardhat')
const { ethers, upgrades } = hre
const { getContracts, saveContract } = require('./utils')

async function main() {
  const network = hre.network.name
  const contracts = await getContracts(network)[network]

  const Collection = await hre.ethers.getContractFactory('Collection')

  const collection = await Collection.attach(
    '0x09eA7a6cfC745835792A4f2a1709c9236e643EeD'
  )
  await collection.deployed()

  console.log('Collection deployed to:', collection.address)

  await hre.run('verify:verify', {
    address: collection.address,
    constructorArguments: [
      'Test Collection',
      'TC',
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

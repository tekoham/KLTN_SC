const hre = require('hardhat')
const { ethers, upgrades } = hre
const { getContracts, saveContract } = require('./utils')

async function main() {
  const network = hre.network.name
  const contracts = await getContracts(network)[network]

  const FixedPrice = await hre.ethers.getContractFactory('FixedPrice')
  // const fixedPrice = await FixedPrice.deploy()
  const fixedPrice = await FixedPrice.attach(contracts.fixedPrice)
  await fixedPrice.deployed()
  await saveContract(network, 'fixedPrice', fixedPrice.address)
  console.log('Fixed Price deployed to:', fixedPrice.address)

  await hre.run('verify:verify', {
    address: fixedPrice.address,
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

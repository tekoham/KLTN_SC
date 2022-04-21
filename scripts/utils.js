const fs = require("fs");
const path = require("path");

function getContracts(network) {
  let json;
  try {
    json = fs.readFileSync(path.join(__dirname, `../configs/${network}.contract-addresses.json`));
  } catch (err) {
    json = "{}";
  }
  const addresses = JSON.parse(json);
  return addresses;
}

function saveContract(network, contract, address) {
  const addresses = getContracts(network);
  addresses[network] = addresses[network] || {};
  addresses[network][contract] = address;
  fs.writeFileSync(
    path.join(__dirname, `../configs/${network}.contract-addresses.json`),
    JSON.stringify(addresses, null, "    ")
  );
}

module.exports = {
  getContracts,
  saveContract,
};

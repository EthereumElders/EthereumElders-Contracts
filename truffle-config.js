const solcStable = {
  version: '0.5.1',
};

const solcNightly = {
  version: 'nightly',
  docker: true,
};

const useSolcNightly = process.env.SOLC_NIGHTLY === 'false';

module.exports = {
  contracts_directory: './contracts',
  networks: {
    development: {
      port: 7545,
     host: '127.0.0.1',
      network_id: '*', // eslint-disable-line camelcase
    },
    coverage: {
      host: 'localhost',
      network_id: '*', // eslint-disable-line camelcase
      port: 8555,
      gas: 0xfffffffffff,
      gasPrice: 0x01,
    },
  },
  compilers: {
    solc: useSolcNightly ? solcNightly : solcStable,
  },
  build: {},
};

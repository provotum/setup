"use strict";
require('dotenv').config();
var fs = require("fs");
var keythereum = require("keythereum");
var axios = require("axios");
const password = "./password.sec";

generateKeys();

function generateKeys() {

    if (process.env.NUMBER_OF_KEYS == undefined) {
        console.log('\x1b[31m', 'Something went wrong with dotenv .env', '\x1b[0m');
        console.log('\x1b[31m', 'Make sure there is a .env file', '\x1b[0m');
        process.exit(1);
        return;
    }

    var addressArray = new Array;
    var privateKeysArray = new Array;
    console.log('\x1b[36m', "Generating ["+process.env.NUMBER_OF_KEYS+"] keys", '\x1b[0m');
    for (var i = 1; i <= process.env.NUMBER_OF_KEYS; i++) {
        var dk = keythereum.create();
        var readableAddress = keythereum.privateKeyToAddress(dk.privateKey);
        addressArray.push(readableAddress);
        privateKeysArray.push(dk.privateKey.toString('hex'));
    }
	
    console.log('\x1b[36m', "Adding 5 nodes from eth-private-net to genesis block.", '\x1b[0m');

	// Always push the five nodes from eth-private-net
	addressArray.push("0x84BcC98723D58203741444B3B4D5660054c812E9");
	addressArray.push("0x32b99e8d3F1A9af00DC742C2069DE3BabA183824");
	addressArray.push("0x556fC148023B893f5d9A18513E33b8Ab0cBa57e7");
	addressArray.push("0x9aAD167D1cABF4FE184FE47c3c30C0f7ae9c2f7c");
	addressArray.push("0x8508453FFB53d5d50a0d3a91e41D5265846ffBa0");

				
    generateJSONForIdentityProvider(privateKeysArray);
    generateGenesisBlock(addressArray);

}

function generateJSONForIdentityProvider(privateKeysArray) {
    var wallets = new Array;

    // Save Each Object containing "private-key" = pkey into the array
    for (var i = 0; i < privateKeysArray.length; i++) {
        var privateKeyObj = {};
        privateKeyObj["private-key"] = privateKeysArray[i];
        wallets.push(privateKeyObj);
    }

    //sendToMockIdentityProvider(wallets);

    var privateKeyJson = JSON.stringify(wallets);
    fs.writeFile('privatekeys.json', privateKeyJson, {}, function () {});
}

function sendToMockIdentityProvider(wallets) {
    axios.defaults.baseURL = process.env.MOCK_IDENTITY_PROVIDER;
    var payload = {wallets};
    axios.post('/wallets', payload)
        .then(function (response) {
            if (response.status == 202);
            console.log('\x1b[36m', "Sucessfully sent private keys to " + axios.defaults.baseURL + "/wallets", '\x1b[0m');
            //console.log(response.status);
        })
        .catch(function (error) {
            console.log('\x1b[91m', "Coulnd't send private keys to http://localhost:8090, is your MOCK_IDENTITY_PROVIDER running?", '\x1b[0m');
            process.exit(1);
            // console.log(error);
        });
}

function generateGenesisBlock(addressArray) {
    console.log('\x1b[36m', "Generating genesis block.", '\x1b[0m');
    var genesisObj = {};

    var clique = {};
    clique.period = parseInt(process.env.GENESIS_CONFIG_CLIQUE_PERIOD);
    clique.epoch = parseInt(process.env.GENESIS_CONFIG_CLIQUE_EPOCH);

    var config = {};
    config.chainId = parseInt(process.env.GENESIS_CONFIG_CHAINID);

    //config.homesteadBlock = parseInt(process.env.GENESIS_CONFIG_HOMESTEADBLOCK);
    //config.eip150Block = parseInt(process.env.GENESIS_CONFIG_EIP150BLOCK);
    //config.eip150Hash = process.env.GENESIS_CONFIG_EIP150HASH;
    //config.eip155Block = parseInt(process.env.GENESIS_CONFIG_EIP150BLOCK);
    //config.eip158Block = parseInt(process.env.GENESIS_CONFIG_EIP158BLOCK);
    //config.byzantiumBlock = parseInt(process.env.GENESIS_CONFIG_BYZANTIUMBLOCK);
    config.clique = clique;
    genesisObj.config = config;

    genesisObj.nonce = process.env.GENESIS_NONCE;
    genesisObj.timestamp = process.env.GENESIS_TIMESTAMP;
    genesisObj.extradata = process.env.GENESIS_EXTRADATA;
    genesisObj.gaslimit = process.env.GENESIS_GASLIMIT;
    genesisObj.difficulty = process.env.GENESIS_DIFFICULTY
    genesisObj.mixhash = process.env.GENESIS_MIXHASH;
    genesisObj.coinbase = process.env.GENESIS_COINBASE;
    genesisObj.alloc = createPreAllocObject(addressArray);
    genesisObj.number = process.env.GENESIS_NUMBER;
    genesisObj.gasUsed = process.env.GENESIS_GASUSED;
    genesisObj.parentHash = process.env.GENESIS_PARENTHASH;

    
    var genesisJson = JSON.stringify(genesisObj);
    fs.writeFile('genesis.json', genesisJson, {}, function () {});

}

function createPreAllocObject(addressArray) {
    var balanceObj = {};
    balanceObj.balance = process.env.GENESIS_ALLOC_BALANCE;
    var preAllocObject = {};

    for (var i = 0; i < addressArray.length; i++) {
        var currentAddress = addressArray[i];
        preAllocObject[currentAddress] = balanceObj;
    }
    return preAllocObject;
}

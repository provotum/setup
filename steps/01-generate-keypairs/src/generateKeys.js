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
        return;
    }

    var addressArray = new Array;
    var privateKeysArray = new Array;
    for (var i = 1; i <= process.env.NUMBER_OF_KEYS; i++) {
        console.log('\x1b[32m', "Generating [" + i + "/" + process.env.NUMBER_OF_KEYS + "] keys", '\x1b[0m');
        var dk = keythereum.create();
        var readableAddress = keythereum.privateKeyToAddress(dk.privateKey);
        addressArray.push(readableAddress);
        privateKeysArray.push(dk.privateKey.toString('hex'));

        // TODO Export the first 5 keystores to the individual folders for use with the eth-private-net
        // TODO folders node1,node2,node3,node4,node5 in /resources/eth-private-net

        //var keyObject = keythereum.dump(password, dk.privateKey, dk.salt, dk.iv);
        //keythereum.exportToFile(keyObject);
    }
	
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

    sendToMockIdentityProvider(wallets);

    var privateKeyJson = JSON.stringify(wallets);
    fs.writeFile('privatekeys.json', privateKeyJson);
}

function sendToMockIdentityProvider(wallets) {
    axios.defaults.baseURL = process.env.MOCK_IDENTITY_PROVIDER;
    var payload = {wallets};
    axios.post('/wallets', payload)
        .then(function (response) {
            if (response.status == 202);
            console.log('\x1b[32m', "Sucessfully sent private keys to " + axios.defaults.baseURL + "/wallets", '\x1b[0m');
            //console.log(response.status);
        })
        .catch(function (error) {
            console.log(error);
        });
}

function generateGenesisBlock(addressArray) {
    console.log('\x1b[32m', "Generating genesis block.", '\x1b[0m');
    var genesisObj = {};

    genesisObj.nonce = process.env.GENESIS_NONCE;
    genesisObj.mixhash = process.env.GENESIS_MIXHASH;
    genesisObj.difficulty = process.env.GENESIS_DIFFICULTY
    genesisObj.coinbase = process.env.GENESIS_COINBASE;
    genesisObj.alloc = createPreAllocObject(addressArray);
    genesisObj.timestamp = process.env.GENESIS_TIMESTAMP;
    genesisObj.extradata = process.env.GENESIS_EXTRADATA;
    genesisObj.gaslimit = process.env.GENESIS_GASLIMIT;
    genesisObj.timestamp = process.env.GENESIS_TIMESTAMP;
    genesisObj.parentHash = process.env.GENESIS_PARENTHASH;

    var config = {};
    config.chainId = 15;
    config.homesteadBlock = 0;
    config.eip155Block = 0;
    config.eip158Block = 0;
    genesisObj.config = config;

    var genesisJson = JSON.stringify(genesisObj);
    fs.writeFile('genesis.json', genesisJson);

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

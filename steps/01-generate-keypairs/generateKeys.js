"use strict";

require('dotenv').config();
var fs = require("fs");
var keythereum = require("keythereum");
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

        //var keyObject = keythereum.dump(password, dk.privateKey, dk.salt, dk.iv);
        //keythereum.exportToFile(keyObject);
    }

    generateJSONForIdentityProvider(privateKeysArray);
    generateGenesisBlock(addressArray);

}

function generateJSONForIdentityProvider(privateKeysArray) {
    var privateKeyObj = {};
    for (var i = 0; i < privateKeysArray.length; i++) {
        privateKeyObj[i] = privateKeysArray[i];
    }
    var privateKeyJson = JSON.stringify(privateKeyObj);
    fs.writeFile('privatekeys.json', privateKeyJson);
}


function generateGenesisBlock(addressArray) {
    console.log('\x1b[32m', "Generating genesis block.", '\x1b[0m');
    var genesisObj = {};

    genesisObj.nonce = process.env.GENESIS_NONCE;
    genesisObj.mixhash = process.env.GENESIS_MIXHASH;
    genesisObj.difficulty = process.env.GENESIS_NONCE
    genesisObj.coinbase = process.env.GENESIS_NONCE;
    genesisObj.alloc = createPreAllocObject(addressArray);
    genesisObj.timestamp = process.env.GENESIS_TIMESTAMP;
    genesisObj.extradata = process.env.GENESIS_EXTRADATA;
    genesisObj.gaslimit = process.env.GENESIS_GASLIMIT;
    genesisObj.timestamp = process.env.GENESIS_TIMESTAMP;
    genesisObj.parentHash = process.env.GENESIS_PARENTHASH;
    genesisObj.parentHash = process.env.GENESIS_PARENTHASH;

    var config = {};
    config.chainId = process.env.GENESIS_CHAINID;
    config.homesteadBlock = process.env.GENESIS_HOMESTEADBLOCK;
    config.eip155Block = process.env.GENESIS_EIP155BLOCK;
    config.eip158Block = process.env.GENESIS_EIP158BLOCK;
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

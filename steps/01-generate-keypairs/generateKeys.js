"use strict";

require('dotenv').config();
var fs = require("fs");
var keythereum = require("keythereum");
const password = "./password.sec";

generateKeys();

function generateKeys() {

    if (process.env.NUMBER_OF_KEYS == undefined) {
        console.log('\x1b[31m','Something went wrong with dotenv .env','\x1b[0m');
        return;
    }

    // TODO Generate 100 private keys and save them to a JSON according to the mock-identity provider format


    for (var i=1; i < process.env.NUMBER_OF_KEYS; i++) {
        console.log('\x1b[32m',"Generating ["+i+"/"+ process.env.NUMBER_OF_KEYS + "] keys",'\x1b[0m');
        var dk = keythereum.create();
        var keyObject = keythereum.dump(password, dk.privateKey, dk.salt, dk.iv);
        keythereum.exportToFile(keyObject);
    }

    // TODO  Get all the addresses of the corresponding private keys to create a genesis file containing all those 100 addresses


    // TODO Then, run the private network (eth-private-net) with the genesis file that was just generated
    // TODO Add eth-private net as submodule?

    // TODO This concludes step 1, the proxy contract can now be deployed --> Step 2


}

// Format for private key file that needs to be POSTed to the server
/* {
"wallets": [
    {
        "private-key": "0"
    },
    {
        "private-key": "1"
    },
    {
        "private-key": "2"
    }
]
}*/
#!/usr/bin/env bash
GREEN=$(tput setaf 2)

(cd $(pwd)/steps/01-generate-keypairs/src && npm install);
(cd $(pwd)/resources/eth-private-net/eth-net-intelligence-api && sudo npm install -g pm2);
(cd $(pwd)/resources/eth-private-net/eth-net-intelligence-api && npm install);

(cd $(pwd)/resources/eth-private-net/eth-netstats && sudo npm install -g grunt-cli);
(cd $(pwd)/resources/eth-private-net/eth-netstats && npm install);
(cd $(pwd)/resources/eth-private-net/eth-netstats && grunt all);


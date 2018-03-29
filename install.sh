#!/usr/bin/env bash
GREEN=$(tput setaf 2)

git submodule init && git submodule update

(cd $(pwd)/resources/poa-private-net && git submodule init);
(cd $(pwd)/resources/poa-private-net && git submodule update);

(cd $(pwd)/steps/01-deploy-poa-net/src && npm install);

(cd $(pwd)/resources/poa-private-net/eth-net-intelligence-api && sudo npm install -g pm2);
(cd $(pwd)/resources/poa-private-net/eth-net-intelligence-api && npm install);

(cd $(pwd)/resources/poa-private-net/eth-netstats && sudo npm install -g grunt-cli);
(cd $(pwd)/resources/poa-private-net/eth-netstats && npm install);
(cd $(pwd)/resources/poa-private-net/eth-netstats && grunt all);



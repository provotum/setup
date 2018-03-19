#!/usr/bin/env bash
GREEN=$(tput setaf 2)

git submodule init && git submodule update

(cd $(pwd)/resources/poa-private-net && git submodule init);
(cd $(pwd)/resources/poa-private-net && git submodule update);

(cd $(pwd)/steps/01-generate-keypairs/src && npm install);
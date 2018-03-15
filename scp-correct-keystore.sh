#/bin/bash

SSH_KEY="~/.ssh/poa"

LOCAL_KEYSTORE_SEALER02="$(pwd)/resources/poa-private-net/node2/keystore/UTC--2018-02-07T11-37-07.735170157Z--84bcc98723d58203741444b3b4d5660054c812e9"
LOCAL_KEYSTORE_SEALER03="$(pwd)/resources/poa-private-net/node3/keystore/UTC--2018-02-07T11-37-07.753794209Z--8508453ffb53d5d50a0d3a91e41d5265846ffba0"
LOCAL_KEYSTORE_SEALER04="$(pwd)/resources/poa-private-net/node4/keystore/UTC--2018-02-07T11-37-07.753350073Z--32b99e8d3f1a9af00dc742c2069de3baba183824"
LOCAL_KEYSTORE_SEALER05="$(pwd)/resources/poa-private-net/node5/keystore/UTC--2018-02-07T11-37-07.774351859Z--9aad167d1cabf4fe184fe47c3c30c0f7ae9c2f7c"

REMOTE_DEPLOY_TARGET="provotum/node/keystore"

scp -i $SSH_KEY $LOCAL_KEYSTORE_SEALER02 authority@sealer02.provotum.ch:~/$REMOTE_DEPLOY_TARGET;
scp -i $SSH_KEY $LOCAL_KEYSTORE_SEALER03 authority@sealer03.provotum.ch:~/$REMOTE_DEPLOY_TARGET;
scp -i $SSH_KEY $LOCAL_KEYSTORE_SEALER04 authority@sealer04.provotum.ch:~/$REMOTE_DEPLOY_TARGET;
scp -i $SSH_KEY $LOCAL_KEYSTORE_SEALER05 authority@sealer05.provotum.ch:~/$REMOTE_DEPLOY_TARGET;
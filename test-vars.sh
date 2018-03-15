#/bin/bash

string="admin.addPeer(\""
echo $string;

EXT_IP[0]="46.101.98.114"
EXT_IP[1]="138.197.176.96"
EXT_IP[2]="159.65.116.125"
EXT_IP[3]="138.68.89.116"
EXT_IP[4]="138.68.86.102"

COUNTER=1;
  EXTERNAL_IP=${EXT_IP[$COUNTER]}
echo "$EXTERNAL_IP"
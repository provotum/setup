RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
CYAN=$(tput setaf 6)
NORMAL=$(tput sgr0)
YELLOW=$(tput setaf 3)

#Color	Code
#Black		0
#Red		1
#Green		2
#Yellow		3
#Blue		4
#Magenta	5
#Cyan		6
#White		7

# calling key generation with node
printf "${CYAN}Starting 5 nodes for a private network \n${NORMAL}"

printf "${CYAN}Copying genesis.json over from pwd to resources/eth-private-net\n${NORMAL}"
cp $(pwd)/genesis.json $(pwd)/resources/eth-private-net/

printf "${CYAN}Starting bash eth-private-net \n${NORMAL}"
(cd $(pwd)/resources/eth-private-net/ && bash ./run.sh);
(cd $(pwd)/resources/eth-private-net/ && bash ./startmining.sh);

printf "${NORMAL}"

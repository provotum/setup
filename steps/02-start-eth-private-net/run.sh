RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
CYAN=$(tput setaf 6)
NORMAL=$(tput sgr0)
YELLOW=$(tput setaf 3)

# calling key generation with node
printf "${CYAN}Starting 5 nodes for a private network \n${NORMAL}"

printf "${CYAN}Copying genesis.json over from pwd to resources/eth-private-net\n${NORMAL}"
cp $(pwd)/genesis.json $(pwd)/resources/poa-private-net/

printf "${CYAN}Starting bash eth-private-net \n${NORMAL}"
(cd $(pwd)/resources/poa-private-net/ && bash ./run.sh);

printf "${NORMAL}"

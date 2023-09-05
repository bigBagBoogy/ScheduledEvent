source .env

forge script script/DeployLevelUp.s.sol:DeployLevelUp --rpc-url $SEPOLIA_RPC_URL --private-key $PRIVATE_KEY --broadcast --verify --etherscan-api-key $ETHERSCAN_API_KEY -vv

# 0: contract LevelUp 0x6F0E7DF445F9dE8BF717949F200105D863679ad7

increment() => 0xb1dc65a4

##

git init
git branch -M main
git add .
git commit -m "amended code"
git push -u origin main

##

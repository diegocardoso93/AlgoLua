<p align="center"> 
	<img src="https://cloudflare-ipfs.com/ipfs/bafkreifhlj7il5pcygo5h5auw6bdafpxbuex4o2echdgoa7waiudkwtpze">
</p>

# AlgoLua
This project is focused on creating the Algorand Lua SDK so that developers can integrate Algorand features with the most common game engines that use the Lua scripting language. The initial plan is to support Defold, Solar2D (Corona SDK), LÖVE. [WIP]

⚠ `this project is not audited and should not be used in a production environment.`

### Quick Start
```
local algod = require("AlgoLua.Api.Algod")

algod.token = "Your algod API token"
algod.address = "http://localhost:8080"

algod.genesis(function(data) pprint(data) end, function(error) pprint(error) end)
```

## Currently support
#### API Algod
|                     | Defold  | Solar2D |  Löve   |
| ------------------- | ------- | ------- | ------- |
| All search methods  | &#9745; | &#9745; | &#9745; |
| Make transactions   | &#9744; | &#9744; | &#9744; |
| Create assets       | &#9744; | &#9744; | &#9744; |
| Create applications | &#9744; | &#9744; | &#9744; |
#### API Indexer
|                     | Defold  | Solar2D |  Löve   |
| ------------------- |-------- | ------- | ------- |
| All search methods  | &#9745; | &#9745; | &#9745; |
#### WalletConnect protocol
|                                    | Defold  | Solar2D |  Löve   |
| ---------------------------------- | ------- | ------- | ------- |
| Create QRCode                      | &#9745; | &#9745; | &#9744; |
| Account balance (list assets)      | &#9745; | &#9745; | &#9744; |
| Select network (testnet, mainnet)  | &#9745; | &#9745; | &#9744; |
| Sign pay transaction               | &#9744; | &#9744; | &#9744; |
| Sign asset opt-in transaction      | &#9744; | &#9744; | &#9744; |
| Sign asset transfer transaction    | &#9744; | &#9744; | &#9744; |
| Sign app opt-in transaction        | &#9744; | &#9744; | &#9744; |
| Sign app call transaction          | &#9744; | &#9744; | &#9744; |

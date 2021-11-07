<p align="center"> 
	<img src="https://cloudflare-ipfs.com/ipfs/bafkreifhlj7il5pcygo5h5auw6bdafpxbuex4o2echdgoa7waiudkwtpze">
</p>

# AlgoLua
This project is focused on creating the Algorand Lua SDK so that developers can integrate Algorand features with the most common game engines that use the Lua scripting language. The initial plan is to support Defold, LÖVE, and Roblox Studio.

## Quick Start
```
local algod = require("AlgoLua.Algod")

algod.token = "Your algod API token"
algod.address = "http://localhost:8080"

algod.genesis(function(data) print(data) end, function(error) print(error) end)
```

-- Tests using Algorand Sandbox
-- To run, you need to put:
-- require "AlgoLua.Tests.Indexer"
-- https://github.com/algorand/sandbox

local indexer = require("AlgoLua.Indexer")
indexer.address = "http://localhost:8980"
indexer.token = "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"

local TEST_ACCOUNT = "TILEGPKJK6NTQUZOSG7PJYTYLW2TJS6COMKFQWBOJ5B7OQKZW2QBGSKULU"

print("Indexer - Running tests...")
print("indexer.health")
indexer.health(function(data)
	assert(data["db-available"])
end, function(error) assert(false) end)

print("indexer.accounts")
indexer.accounts(nil, function(data)
	assert(data["accounts"])

	print("indexer.block")
	indexer.block(data["accounts"][1]["round"], nil, function(data)
		assert(data["rewards"])
	end, function(error) assert(false) end)
end, function(error) assert(false) end)

print("indexer.account")
indexer.account(TEST_ACCOUNT, nil, function(data)
	assert(data["account"])
end, function(error) assert(false) end)

print("indexer.account_transactions")
indexer.account_transactions(TEST_ACCOUNT, nil, function(data)
	assert(data["transactions"])
end, function(error) assert(false) end)

print("indexer.applications")
indexer.applications(nil, function(data)
	assert(data["applications"])
end, function(error) assert(false) end)

print("indexer.assets")
indexer.assets(nil, function(data)
	assert(data["assets"])
end, function(error) assert(false) end)

print("indexer.transactions")
indexer.transactions(nil, function(data)
	assert(data["transactions"])
end, function(error) assert(false) end)

--[[
@todo create application before test
indexer.application
Indexer.application_logs

@todo create asset before test
Indexer.asset
Indexer.asset_balances
Indexer.asset_transactions
Indexer.transaction
--]]

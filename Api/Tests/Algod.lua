-- Tests using Algorand Sandbox
-- To run, you need to put:
-- require "AlgoLua.Api.Tests.Algod"
-- https://github.com/algorand/sandbox

local algod = require("AlgoLua.Api.Algod")
algod.address = "http://localhost:4001"
algod.token = "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"

local TEST_ACCOUNT = "TILEGPKJK6NTQUZOSG7PJYTYLW2TJS6COMKFQWBOJ5B7OQKZW2QBGSKULU"

print("Algod - Running tests...")
print("algod.genesis")
algod.genesis(function(data)
	assert(type(data) == "table")
end, function(error) assert(false) end)

print("algod.health")
algod.health(function(data)
	assert(data == nil)
end, function(error) assert(false) end)

print("algod.versions")
algod.versions(function(data)
	assert(type(data) == "table")
end, function(error) assert(false) end)

print("algod.account")
algod.account(TEST_ACCOUNT, function(data)
	assert(data["status"] ~= nil)
end, function(error) assert(false) end)

print("algod.account_transactions_pending")
algod.account_transactions_pending(TEST_ACCOUNT, { max = 1 }, function(data)
	assert(#data["top-transactions"] == 1 or #data["top-transactions"] == 0)
	assert(data["total-transactions"] ~= nil)
end, function(error) assert(false) end)

--[[
-- @todo after first transaction
algod.application
algod.asset
algod.block
algod.block_transaction_proof
catchup_start
catchup_abort
register_participation_key
status_after_block
]]--

print("algod.ledger_supply")
algod.ledger_supply(function(data)
	assert(data["total-money"] ~= nil)
end, function(error) assert(false) end)

print("algod.status")
algod.status(function(data)
	assert(data)
end, function(error) assert(false) end)

print("algod.teal_compile")
algod.teal_compile({ source = "int 1" }, function(data)
	assert(data.result == "////////////AQ==")
end, function(error) assert(false) end)

print("algod.transaction_params")
algod.transaction_params(function(params)
	assert(params["fee"] ~= nil)

	local note = "Hello World"
	local receiver = "FSFCIWLMZ5O4BDWVO2XZ7Q2NZVT7SUJEZ5D23TG5MRPMBBIXNDDGO7CDMM"

	-- @todo ed25519 or other way to sign transaction

	--print("algod.raw_transaction")
	--algod.raw_transaction(params, function(data)
	--	pprint(data)
	--end, function(error) assert(false) end)
end, function(error) assert(false) end)

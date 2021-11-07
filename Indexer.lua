-- Put functions in this file to use them in several other scripts.
-- To get access to the functions, you need to put:
-- require "AlgoLua.Indexer"
-- in any script using the functions.
-- Indexer API reference: https://developer.algorand.org/docs/rest-apis/indexer/

local http_client = require("AlgoLua.HttpClient")

local Indexer = {
	address = nil,
	token = nil
}

function headers()
	return { ["x-api-key"] = Indexer.token }
end

function Indexer.health(on_success, on_error)
	http_client.get(Indexer.address .. "/health", headers(), on_success, on_error)
end

function Indexer.accounts(on_success, on_error)
	--[[
	@Optional parameters:
	application-id: integer,
	asset-id: integer,
	auth-addr: string
	currency-greater-than: integer
	currency-less-than: integer
	include-all: boolean
	limit: integer
	next: string
	round: integer
	]]
	http_client.get(Indexer.address .. "/v2/accounts", headers(), on_success, on_error)
end

function Indexer.account(account_id, on_success, on_error)
	--[[
	@Optional parameters:
	include-all: boolean,
	round: integer
	]]
	http_client.get(Indexer.address .. "/v2/accounts/" .. account_id, headers(), on_success, on_error)
end

function Indexer.account_transactions(account_id, on_success, on_error)
	--[[
	@Optional parameters:
	after-time: string(date-time),
	asset-id: integer,
	before-time: string(date-time),
	currency-greater-than: integer,
	currency-less-than: integer,
	limit: integer,
	max-round: integer,
	min-round: integer,
	next: string,
	note-prefix: string,
	rekey-to: boolean,
	round: integer,
	sig-type: enum (sig, msig, lsig),
	tx-type: enum (pay, keyreg, acfg, axfer, afrz, appl),
	txid: string,
	]]
	http_client.get(Indexer.address .. "/v2/accounts/" .. account_id .. "/transactions", headers(), on_success, on_error)
end

function Indexer.applications(on_success, on_error)
	--[[
	@Optional parameters:
	include-all: boolean,
	limit: integer,
	next: string,
	]]
	http_client.get(Indexer.address .. "/v2/applications", headers(), on_success, on_error)
end

function Indexer.application(application_id, on_success, on_error)
	--[[
	@Optional parameters:
	include-all: boolean,
	]]
	http_client.get(Indexer.address .. "/v2/applications/" .. application_id, headers(), on_success, on_error)
end

function Indexer.application_logs(application_id, on_success, on_error)
	--[[
	@Optional parameters:
	limit: integer,
	max-round: integer,
	min-round: integer,
	next: string,
	sender-address: string,
	txid: string,
	]]
	http_client.get(Indexer.address .. "/v2/applications/" .. application_id .. "/logs", headers(), on_success, on_error)
end

function Indexer.assets(on_success, on_error)
	--[[
	@Optional parameters:
	asset-id: integer,
	creator: string,
	include-all: boolean,
	limit: integer,
	name: string,
	next: string,
	unit: string,
	]]
	http_client.get(Indexer.address .. "/v2/assets", headers(), on_success, on_error)
end

function Indexer.asset(asset_id, on_success, on_error)
	--[[
	@Optional parameters:
	include-all: string,
	]]
	http_client.get(Indexer.address .. "/v2/assets/" .. asset_id, headers(), on_success, on_error)
end

function Indexer.asset_balances(asset_id, on_success, on_error)
	--[[
	@Optional parameters:
	currency-greater-than: integer,
	currency-less-than: integer,
	include-all: boolean,
	limit: integer,
	next: string,
	round: integer,
	]]
	http_client.get(Indexer.address .. "/v2/assets/" .. asset_id .. "/balances", headers(), on_success, on_error)
end

function Indexer.asset_transactions(asset_id, on_success, on_error)
	--[[
	@Optional parameters:
	address: integer,
	address-role: enum (sender, receiver, freeze-target),
	after-time: string (date-time),
	before-time: string (date-time),
	currency-greater-than: integer,
	currency-less-than: integer,
	exclude-close-to: boolean,
	limit: integer,
	max-round: integer,
	min-round: integer,
	next: string,
	note-prefix: string,
	rekey-to: boolean,
	round: integer,
	sig-type: enum (sig, msig, lsig),
	tx-type: enum (pay, keyreg, acfg, axfer, afrz, appl),
	txid: string,
	]]
	http_client.get(Indexer.address .. "/v2/assets/" .. asset_id .. "/transactions", headers(), on_success, on_error)
end

function Indexer.block(round_number, on_success, on_error)
	http_client.get(Indexer.address .. "/v2/blocks/" .. round_number, headers(), on_success, on_error)
end

function Indexer.transactions(on_success, on_error)
	--[[
	@Optional parameters:
	address: integer,
	address-role: enum (sender, receiver, freeze-target),
	after-time: string (date-time),
	application-id: integer,
	asset-id: integer,
	before-time: string (date-time),
	currency-greater-than: integer,
	currency-less-than: integer,
	exclude-close-to: boolean,
	limit: integer,
	max-round: integer,
	min-round: integer,
	next: string,
	note-prefix: string,
	rekey-to: boolean,
	round: integer,
	sig-type: enum (sig, msig, lsig),
	tx-type: enum (pay, keyreg, acfg, axfer, afrz, appl),
	txid: string,
	]]
	http_client.get(Indexer.address .. "/v2/transactions", headers(), on_success, on_error)
end

function Indexer.transaction(txid, on_success, on_error)
	http_client.get(Indexer.address .. "/v2/transactions/" .. txid, headers(), on_success, on_error)
end

return Indexer

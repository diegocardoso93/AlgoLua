-- Put functions in this file to use them in several other scripts.
-- To get access to the functions, you need to put:
-- require "AlgoLua.Api.Algod"
-- in any script using the functions.
-- Algod API documentation: https://developer.algorand.org/docs/rest-apis/algod/v2/

local http_client = require("AlgoLua.Api.HttpClient")
local http_utils = require("AlgoLua.Api.HttpUtils")

local Algod = {
	address = nil,
	token = nil
}

local function headers()
	return {
		["x-api-key"] = Algod.token,
		["X-Algo-API-Token"] = Algod.token
	}
end

-- @Method:
--  Algod.genesis
--  Gets the genesis information.
-- @Input:
--  - on_success: function (data) | nil
--  - on_error: function (data) | nil
function Algod.genesis(on_success, on_error)
	http_client.get(Algod.address .. "/genesis", headers(), on_success, on_error)
end

-- @Method:
--  Algod.health
--  Returns OK if healthy.
-- @Input:
--  - on_success: function (data) | nil
--  - on_error: function (data) | nil
function Algod.health(on_success, on_error)
	http_client.get(Algod.address .. "/health", headers(), on_success, on_error)
end

-- @Method:
--  Algod.versions
--  Retrieves the supported API versions, binary build versions, and genesis information.
-- @Input:
--  - on_success: function (data) | nil
--  - on_error: function (data) | nil
function Algod.versions(on_success, on_error)
	http_client.get(Algod.address .. "/versions", headers(), on_success, on_error)
end

-- @Method:
--  Algod.account
--  Get account information.
-- @Input:
--  - address: string
--  - on_success: function (data) | nil
--  - on_error: function (data) | nil
function Algod.account(address, on_success, on_error)
	http_client.get(Algod.address .. "/v2/accounts/" .. address, headers(), on_success, on_error)
end

-- @Method:
--  Algod.account_transactions_pending
--  Get a list of unconfirmed transactions currently in the transaction pool by address.
-- @Input:
--  - address: string
--  - params: table {
--    max: integer
--  } | nil
--  - on_success: function (data) | nil
--  - on_error: function (data) | nil
function Algod.account_transactions_pending(address, params, on_success, on_error)
	http_client.get(Algod.address .. "/v2/accounts/" .. address .. "/transactions/pending?" .. http_utils.query_string(params), headers(), on_success, on_error)
end

-- @Method:
--  Algod.application
--  Get application information.
-- @Input:
--  - application_id: integer
--  - on_success: function (data) | nil
--  - on_error: function (data) | nil
function Algod.application(application_id, on_success, on_error)
	http_client.get(Algod.address .. "/v2/applications/" .. application_id, headers(), on_success, on_error)
end

-- @Method:
--  Algod.asset
--  Get asset information.
-- @Input:
--  - asset_id: integer
--  - on_success: function (data) | nil
--  - on_error: function (data) | nil
function Algod.asset(asset_id, on_success, on_error)
	http_client.get(Algod.address .. "/v2/assets/" .. asset_id, headers(), on_success, on_error)
end

-- @Method:
--  Algod.block
--  Get the block for the given round.
-- @Input:
--  - round: integer
--  - on_success: function (data) | nil
--  - on_error: function (data) | nil
function Algod.block(round, on_success, on_error)
	http_client.get(Algod.address .. "/v2/blocks/" .. round, headers(), on_success, on_error)
end

-- @Method:
--  Algod.block_transaction_proof
--  Get a Merkle proof for a transaction in a block.
-- @Input:
--  - round: integer
--  - txid: string
--  - on_success: function (data) | nil
--  - on_error: function (data) | nil
function Algod.block_transaction_proof(round, txid, on_success, on_error)
	http_client.get(Algod.address .. "/v2/blocks/" .. round .. "/transactions/" .. txid .. "/proof", headers(), on_success, on_error)
end

-- @Method:
--  Algod.catchup_start
--  Starts a catchpoint catchup.
-- @Input:
--  - catchpoint: string
--  - on_success: function (data) | nil
--  - on_error: function (data) | nil
function Algod.catchup_start(catchpoint, on_success, on_error)
	http_client.post(Algod.address .. "/v2/catchup/" .. catchpoint, headers(), nil, on_success, on_error)
end

-- @Method:
--  Algod.catchup_abort
--  Aborts a catchpoint catchup.
-- @Input:
--  - catchpoint: string
--  - on_success: function (data) | nil
--  - on_error: function (data) | nil
function Algod.catchup_abort(catchpoint, on_success, on_error)
	http_client.delete(Algod.address .. "/v2/catchup/" .. catchpoint, headers(), on_success, on_error)
end

-- @Method:
--  Algod.ledger_supply
--  Get the current supply reported by the ledger.
-- @Input:
--  - on_success: function (data) | nil
--  - on_error: function (data) | nil
function Algod.ledger_supply(on_success, on_error)
	http_client.get(Algod.address .. "/v2/ledger/supply", headers(), on_success, on_error)
end

-- @Method:
--  Algod.register_participation_key
--  Generate (or renew) and register participation keys on the node for a given account address.
-- @Input:
--  - address: string
--  - params: table {
--    fee: integer (default = 1000),
--    key-dilution: integer,
--    no-wait: boolean,
--    round-last-valid: integer
--  } | nil
--  - on_success: function (data) | nil
--  - on_error: function (data) | nil
function Algod.register_participation_key(address, on_success, on_error)
	http_client.post(Algod.address .. "/v2/register-participation-keys/" .. address, headers(), on_success, on_error)
end

-- @Method:
--  Algod.status
--  Gets the current node status.
-- @Input:
--  - on_success: function (data) | nil
--  - on_error: function (data) | nil
function Algod.status(on_success, on_error)
	http_client.get(Algod.address .. "/v2/status", headers(), on_success, on_error)
end

-- @Method:
--  Algod.status_after_block
--  Gets the node status after waiting for the given round.
-- @Input:
--  - round: integer
--  - on_success: function (data) | nil
--  - on_error: function (data) | nil
function Algod.status_after_block(round, on_success, on_error)
	http_client.get(Algod.address .. "/v2/status/wait-for-block-after/" .. round, headers(), on_success, on_error)
end

-- @Method:
--  Algod.teal_dryrun
--  Compile TEAL source code to binary, produce its hash.
-- @Input:
--  - body: table {
--    source: string (binary)
--  } | nil
--  - on_success: function (data) | nil
--  - on_error: function (data) | nil
function Algod.teal_compile(body, on_success, on_error)
	http_client.post(Algod.address .. "/v2/teal/compile", body, headers(), on_success, on_error)
end

-- @Method:
--  Algod.raw_transaction
--  Broadcasts a raw transaction to the network.
-- @Input:
--  - body: table {
--    rawtxn: string (binary)
--  } | nil
--  - on_success: function (data) | nil
--  - on_error: function (data) | nil
function Algod.raw_transaction(body, on_success, on_error)
	http_client.post(Algod.address .. "/v2/transactions", body, headers(), on_success, on_error)
end

-- @Method:
--  Algod.transaction_params
--  Get parameters for constructing a new transaction
-- @Input:
--  - on_success: function (data) | nil
--  - on_error: function (data) | nil
function Algod.transaction_params(on_success, on_error)
	http_client.get(Algod.address .. "/v2/transactions/params", headers(), on_success, on_error)
end

-- @Method:
--  Algod.transactions_pending
--  Get a list of unconfirmed transactions currently in the transaction pool.
-- @Input:
--  - txid: integer
--  - params: table {
--    max: integer
--  } | nil
--  - on_success: function (data) | nil
--  - on_error: function (data) | nil
function Algod.transactions_pending(params, on_success, on_error)
	http_client.get(Algod.address .. "/v2/transactions/pending/?" .. http_utils.query_string(params), headers(), on_success, on_error)
end

-- @Method:
--  Algod.transaction_pending
--  Get a specific pending transaction.
-- @Input:
--  - txid: integer
--  - on_success: function (data) | nil
--  - on_error: function (data) | nil
function Algod.transaction_pending(txid, on_success, on_error)
	http_client.get(Algod.address .. "/v2/transactions/pending/" .. txid, headers(), on_success, on_error)
end

return Algod

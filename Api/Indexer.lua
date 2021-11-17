-- Put functions in this file to use them in several other scripts.
-- To get access to the functions, you need to put:
-- require "AlgoLua.Api.Indexer"
-- in any script using the functions.
-- Indexer API reference: https://developer.algorand.org/docs/rest-apis/indexer/

local http_client = require("AlgoLua.Api.HttpClient")
local http_utils = require("AlgoLua.Api.HttpUtils")

local Indexer = {
	address = nil,
	token = nil
}

local function headers()
	return {
		["x-api-key"] = Indexer.token,
		["X-Indexer-API-Token"] = Indexer.token
	}
end

-- @Method:
--  Indexer.health
--  Returns 200 if healthy.
-- @Input:
--  - on_success: function (data) | nil
--  - on_error: function (data) | nil
function Indexer.health(on_success, on_error)
	http_client.get(Indexer.address .. "/health", headers(), on_success, on_error)
end

-- @Method:
--  Indexer.accounts
--  Search for accounts.
-- @Input:
--  - address: string
--  - params: table {
--    application-id: integer,
--    asset-id: integer,
--    auth-addr: string,
--    currency-greater-than: integer,
--    currency-less-than: integer,
--    include-all: boolean,
--    limit: integer,
--    next: string,
--    round: integer
--  } | nil
--  - on_success: function (data) | nil
--  - on_error: function (data) | nil
function Indexer.accounts(params, on_success, on_error)
	http_client.get(Indexer.address .. "/v2/accounts?" .. http_utils.query_string(params), headers(), on_success, on_error)
end

-- @Method:
--  Indexer.accounts
--  Lookup account information.
-- @Input:
--  - account_id: string
--  - params: table {
--    include-all: boolean,
--    round: integer
--  } | nil
--  - on_success: function (data) | nil
--  - on_error: function (data) | nil
function Indexer.account(account_id, params, on_success, on_error)
	http_client.get(Indexer.address .. "/v2/accounts/" .. account_id .. "?" .. http_utils.query_string(params), headers(), on_success, on_error)
end

-- @Method:
--  Indexer.account_transactions
--  Lookup account transactions.
-- @Input:
--  - account_id: string
--  - params: table {
--    after-time: string (date-time),
--    asset-id: boolean,
--    before-time: string (date-time),
--    currency-greater-than: integer,
--    currency-less-than: integer,
--    limit: integer,
--    max-round: integer,
--    min-round: integer,
--    next: string,
--    note-prefix: string,
--    rekey-to: boolean,
--    round: integer,
--    sig-type: enum (sig, msig, lsig),
--    tx-type: enum (pay, keyreg, acfg, axfer, afrz, appl),
--    txid: string
--  } | nil
--  - on_success: function (data) | nil
--  - on_error: function (data) | nil
function Indexer.account_transactions(account_id, params, on_success, on_error)
	http_client.get(Indexer.address .. "/v2/accounts/" .. account_id .. "/transactions?" .. http_utils.query_string(params), headers(), on_success, on_error)
end

-- @Method:
--  Indexer.applications
--  Search for applications.
-- @Input:
--  - params: table {
--    application-id: integer,
--    include-all: boolean,
--    limit: integer,
--    next: string,
--  } | nil
--  - on_success: function (data) | nil
--  - on_error: function (data) | nil
function Indexer.applications(params, on_success, on_error)
	http_client.get(Indexer.address .. "/v2/applications?" .. http_utils.query_string(params), headers(), on_success, on_error)
end

-- @Method:
--  Indexer.application
--  Lookup application.
-- @Input:
--  - application_id: integer
--  - params: table {
--    include-all: boolean
--  } | nil
--  - on_success: function (data) | nil
--  - on_error: function (data) | nil
function Indexer.application(application_id, params, on_success, on_error)
	http_client.get(Indexer.address .. "/v2/applications/" .. application_id .. "?" .. http_utils.query_string(params), headers(), on_success, on_error)
end

-- @Method:
--  Indexer.application
--  Lookup application logs.
-- @Input:
--  - application_id: integer
--  - params: table {
--    limit: integer,
--    max-round: integer,
--    min-round: integer,
--    next: string,
--    sender-address: string,
--    txid: string
--  } | nil
--  - on_success: function (data) | nil
--  - on_error: function (data) | nil
function Indexer.application_logs(application_id, params, on_success, on_error)
	http_client.get(Indexer.address .. "/v2/applications/" .. application_id .. "/logs?" .. http_utils.query_string(params), headers(), on_success, on_error)
end

-- @Method:
--  Indexer.assets
--  Search for assets.
-- @Input:
--  - params: table {
--    asset-id: integer,
--    creator: string,
--    include-all: boolean,
--    limit: integer,
--    next: string,
--    unit: string,
--  } | nil
--  - on_success: function (data) | nil
--  - on_error: function (data) | nil
function Indexer.assets(params, on_success, on_error)
	http_client.get(Indexer.address .. "/v2/assets?" .. http_utils.query_string(params), headers(), on_success, on_error)
end

-- @Method:
--  Indexer.asset
--  Lookup asset information.
-- @Input:
--  - asset_id: integer
--  - params: table {
--    include-all: boolean,
--  } | nil
--  - on_success: function (data) | nil
--  - on_error: function (data) | nil
function Indexer.asset(asset_id, on_success, on_error)
	http_client.get(Indexer.address .. "/v2/assets/" .. asset_id .. "?" .. http_utils.query_string(params), headers(), on_success, on_error)
end

-- @Method:
--  Indexer.asset_balances
--  Lookup the list of accounts who hold this asset.
-- @Input:
--  - asset_id: integer
--  - params: table {
--    currency-greater-than: integer,
--    currency-less-than: integer,
--    include-all: boolean,
--    limit: integer,
--    next: string,
--    round: integer,
--  } | nil
--  - on_success: function (data) | nil
--  - on_error: function (data) | nil
function Indexer.asset_balances(asset_id, params, on_success, on_error)
	http_client.get(Indexer.address .. "/v2/assets/" .. asset_id .. "/balances?" .. http_utils.query_string(params), headers(), on_success, on_error)
end

-- @Method:
--  Indexer.asset_transactions
--  Lookup transactions for an asset.
-- @Input:
--  - asset_id: integer
--  - params: table {
--    address: string,
--    address-role: enum (sender, receiver, freeze-target),
--    after-time: string (date-time),
--    before-time: string (date-time),
--    currency-greater-than: integer,
--    currency-less-than: integer,
--    exclude-close-to: boolean,
--    limit: integer,
--    max-round: integer,
--    min-round: integer,
--    next: string,
--    note-prefix: string,
--    rekey-to: boolean,
--    round: integer,
--    rekey-to: boolean,
--    sig-type: enum (sig, msig, lsig),
--    tx-type: enum (pay, keyreg, acfg, axfer, afrz, appl),
--    txid: string,
--  } | nil
--  - on_success: function (data) | nil
--  - on_error: function (data) | nil
function Indexer.asset_transactions(asset_id, params, on_success, on_error)
	http_client.get(Indexer.address .. "/v2/assets/" .. asset_id .. "/transactions?" .. http_utils.query_string(params), headers(), on_success, on_error)
end

-- @Method:
--  Indexer.block
--  Lookup block.
-- @Input:
--  - round_number: integer
--  - params: table {
--    address: integer,
--    address-role: enum (sender, receiver, freeze-target),
--    after-time: string (date-time),
--    application-id: integer,
--    asset-id: integer,
--    before-time: string (date-time),
--    currency-greater-than: integer,
--    currency-less-than: integer,
--    exclude-close-to: boolean,
--    limit: integer,
--    max-round: integer,
--    min-round: integer,
--    next: string,
--    note-prefix: string,
--    rekey-to: boolean,
--    round: integer,
--    sig-type: enum (sig, msig, lsig),
--    tx-type: enum (pay, keyreg, acfg, axfer, afrz, appl),
--    txid: string,
--  } | nil
--  - on_success: function (data) | nil
--  - on_error: function (data) | nil
function Indexer.block(round_number, params, on_success, on_error)
	http_client.get(Indexer.address .. "/v2/blocks/" .. round_number .. "?" .. http_utils.query_string(params), headers(), on_success, on_error)
end

-- @Method:
--  Indexer.transactions
--  Search for transactions.
-- @Input:
--  - params: table {
--    address: integer,
--    address-role: enum (sender, receiver, freeze-target),
--    after-time: string (date-time),
--    application-id: integer,
--    asset-id: integer,
--    before-time: string (date-time),
--    currency-greater-than: integer,
--    currency-less-than: integer,
--    exclude-close-to: boolean,
--    limit: integer,
--    max-round: integer,
--    min-round: integer,
--    next: string,
--    note-prefix: string,
--    rekey-to: boolean,
--    round: integer,
--    sig-type: enum (sig, msig, lsig),
--    tx-type: enum (pay, keyreg, acfg, axfer, afrz, appl),
--    txid: string,
--  } | nil
--  - on_success: function (data) | nil
--  - on_error: function (data) | nil
function Indexer.transactions(params, on_success, on_error)
	http_client.get(Indexer.address .. "/v2/transactions?" .. http_utils.query_string(params), headers(), on_success, on_error)
end

-- @Method:
--  Indexer.transaction
--  Lookup a single transaction.
-- @Input:
--  - txid: string
--  - on_success: function (data) | nil
--  - on_error: function (data) | nil
function Indexer.transaction(txid, on_success, on_error)
	http_client.get(Indexer.address .. "/v2/transactions/" .. txid, headers(), on_success, on_error)
end

return Indexer

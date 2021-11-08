-- Put functions in this file to use them in several other scripts.
-- To get access to the functions, you need to put:
-- require "AlgoLua.Kmd"
-- in any script using the functions.
-- Kmd API reference: https://developer.algorand.org/docs/rest-apis/kmd/

local http_client = require("AlgoLua.HttpClient")

local Kmd = {
	address = nil,
	token = nil
}

local function headers()
	return { ["x-api-key"] = Kmd.token }
end

-- @Method:
--  Kmd.key
--  Generates the next key in the deterministic key sequence (as determined by the master derivation key) and adds it to the wallet, returning the public key.
-- @Input:
--  - body: table {
--    display_mnemonic: boolean,
--    wallet_handle_token: string
--  }
--  - on_success: function (data) | nil
--  - on_error: function (data) | nil
function Kmd.key(body, on_success, on_error)
	http_client.post(Kmd.address .. "/v1/key", headers(), body, on_success, on_error)
end

-- @Method:
--  Kmd.delete_key
--  Deletes the key with the passed public key from the wallet.
-- @Input:
--  - body: table {
--    address: string,
--    wallet_handle_token: string,
--    wallet_password: string
--  }
--  - on_success: function (data) | nil
--  - on_error: function (data) | nil
function Kmd.delete_key(body, on_success, on_error)
	http_client.delete(Kmd.address .. "/v1/key", headers(), body, on_success, on_error)
end

-- @Method:
--  Kmd.export_key
--  Export the secret key associated with the passed public key.
-- @Input:
--  - body: table {
--    address: string,
--    wallet_handle_token: string,
--    wallet_password: string
--  }
--  - on_success: function (data) | nil
--  - on_error: function (data) | nil
function Kmd.export_key(body, on_success, on_error)
	http_client.post(Kmd.address .. "/v1/key/export", headers(), body, on_success, on_error)
end

-- @Method:
--  Kmd.import_key
--  Import an externally generated key into the wallet. Note that if you wish to back up the imported key, you must do so
--  by backing up the entire wallet database, because imported keys were not derived from the wallet's master derivation key.
-- @Input:
--  - body: table {
--    private_key: string,
--    wallet_handle_token: string
--  }
--  - on_success: function (data) | nil
--  - on_error: function (data) | nil
function Kmd.import_key(body, on_success, on_error)
	http_client.post(Kmd.address .. "/v1/key/import", headers(), body, on_success, on_error)
end

-- @Method:
--  Kmd.list_keys
--  Lists all of the public keys in this wallet. All of them have a stored private key.
-- @Input:
--  - body: table {
--    wallet_handle_token: string
--  }
--  - on_success: function (data) | nil
--  - on_error: function (data) | nil
function Kmd.list_keys(body, on_success, on_error)
	http_client.post(Kmd.address .. "/v1/key/list", headers(), body, on_success, on_error)
end

-- @Method:
--  Kmd.export_master_key
--  Export the master derivation key from the wallet. This key is a master "backup" key for the underlying wallet.
--  With it, you can regenerate all of the wallets that have been generated with this wallet's POST /v1/key endpoint.
--  This key will not allow you to recover keys imported from other wallets, however.
-- @Input:
--  - body: table {
--    wallet_handle_token: string,
--    wallet_password
--  }
--  - on_success: function (data) | nil
--  - on_error: function (data) | nil
function Kmd.export_master_key(body, on_success, on_error)
	http_client.post(Kmd.address .. "/v1/master-key/export", headers(), body, on_success, on_error)
end

-- @Method:
--  Kmd.delete_multisig
--  Deletes multisig preimage information for the passed address from the wallet.
-- @Input:
--  - body: table {
--    address: string,
--    wallet_handle_token: string,
--    wallet_password: string
--  }
--  - on_success: function (data) | nil
--  - on_error: function (data) | nil
function Kmd.delete_multisig(body, on_success, on_error)
	http_client.delete(Kmd.address .. "/v1/multisig", headers(), body, on_success, on_error)
end

-- @Method:
--  Kmd.export_multisig
--  Given a multisig address whose preimage this wallet stores,
--  returns the information used to generate the address, including public keys, threshold, and multisig version.
-- @Input:
--  - body: table {
--    address: string,
--    wallet_handle_token: string
--  }
--  - on_success: function (data) | nil
--  - on_error: function (data) | nil
function Kmd.export_multisig(body, on_success, on_error)
	http_client.post(Kmd.address .. "/v1/multisig/export", headers(), body, on_success, on_error)
end

-- @Method:
--  Kmd.import_multisig
--  Generates a multisig account from the passed public keys array and multisig metadata, and stores all of this in the wallet.
-- @Input:
--  - body: table {
--    address: string,
--    wallet_handle_token: string
--  }
--  - on_success: function (data) | nil
--  - on_error: function (data) | nil
function Kmd.import_multisig(body, on_success, on_error)
	http_client.post(Kmd.address .. "/v1/multisig/import", headers(), body, on_success, on_error)
end

-- @Method:
--  Kmd.list_multisig
--  Lists all of the multisig accounts whose preimages this wallet stores.
-- @Input:
--  - body: table {
--    wallet_handle_token: string
--  }
--  - on_success: function (data) | nil
--  - on_error: function (data) | nil
function Kmd.list_multisig(body, on_success, on_error)
	http_client.post(Kmd.address .. "/v1/multisig/list", headers(), body, on_success, on_error)
end

-- @Method:
--  Kmd.sign_multisig
--  Start a multisig signature, or add a signature to a partially completed multisig signature object.
-- @Input:
--  - body: table SignMultisigRequest
--  - on_success: function (data) | nil
--  - on_error: function (data) | nil
-- @See SignMultisigRequest https://developer.algorand.org/docs/rest-apis/kmd/#signmultisigrequest
function Kmd.sign_multisig(body, on_success, on_error)
	http_client.post(Kmd.address .. "/v1/multisig/sign", headers(), body, on_success, on_error)
end

-- @Method:
--  Kmd.signprogram_multisig
--  Start a multisig signature, or add a signature to a partially completed multisig signature object.
-- @Input:
--  - body: table SignProgramMultisigRequest
--  - on_success: function (data) | nil
--  - on_error: function (data) | nil
-- @See SignProgramMultisigRequest https://developer.algorand.org/docs/rest-apis/kmd/#signprogrammultisigrequest
function Kmd.signprogram_multisig(body, on_success, on_error)
	http_client.post(Kmd.address .. "/v1/multisig/signprogram", headers(), body, on_success, on_error)
end

-- @Method:
--  Kmd.sign_program
--  Signs the passed program with a key from the wallet, determined by the account named in the request.
-- @Input:
--  - body: table SignProgramMultisigRequest
--  - on_success: function (data) | nil
--  - on_error: function (data) | nil
-- @See SignProgramMultisigRequest https://developer.algorand.org/docs/rest-apis/kmd/#signprogramrequest
function Kmd.sign_program(body, on_success, on_error)
	http_client.post(Kmd.address .. "/v1/program/sign", headers(), body, on_success, on_error)
end

-- @Method:
--  Kmd.sign_transaction
--  Signs the passed transaction with a key from the wallet, determined by the sender encoded in the transaction.
-- @Input:
--  - body: table SignTransactionRequest
--  - on_success: function (data) | nil
--  - on_error: function (data) | nil
-- @See SignTransactionRequest https://developer.algorand.org/docs/rest-apis/kmd/#signtransactionrequest
function Kmd.sign_transaction(body, on_success, on_error)
	http_client.post(Kmd.address .. "/v1/transaction/sign", headers(), body, on_success, on_error)
end

-- @Method:
--  Kmd.create_wallet
--  Create a new wallet (collection of keys) with the given parameters.
-- @Input:
--  - body: table CreateWalletRequest
--  - on_success: function (data) | nil
--  - on_error: function (data) | nil
-- @See CreateWalletRequest https://developer.algorand.org/docs/rest-apis/kmd/#createwalletrequest
function Kmd.create_wallet(body, on_success, on_error)
	http_client.post(Kmd.address .. "/v1/wallet", headers(), body, on_success, on_error)
end

-- @Method:
--  Kmd.wallet
--  Returns information about the wallet associated with the passed wallet handle token.
--  Additionally returns expiration information about the token itself.
-- @Input:
--  - body: table {
--    wallet_handle_token: string
--  }
--  - on_success: function (data) | nil
--  - on_error: function (data) | nil
function Kmd.wallet(body, on_success, on_error)
	http_client.post(Kmd.address .. "/v1/wallet/info", headers(), body, on_success, on_error)
end

-- @Method:
--  Kmd.init_wallet
--  Unlock the wallet and return a wallet handle token that can be used for subsequent operations.
--  These tokens expire periodically and must be renewed. You can POST the token to /v1/wallet/info to see how much time remains until expiration,
--  and renew it with /v1/wallet/renew. When you're done, you can invalidate the token with
-- @Input:
--  - body: table {
--    wallet_id: string,
--    wallet_password: string
--  }
--  - on_success: function (data) | nil
--  - on_error: function (data) | nil
function Kmd.init_wallet(body, on_success, on_error)
	http_client.post(Kmd.address .. "/v1/wallet/init", headers(), body, on_success, on_error)
end

-- @Method:
--  Kmd.release_wallet
--  Invalidate the passed wallet handle token, making it invalid for use in subsequent requests.
-- @Input:
--  - body: table {
--    wallet_handle_token: string
--  }
--  - on_success: function (data) | nil
--  - on_error: function (data) | nil
function Kmd.release_wallet(body, on_success, on_error)
	http_client.post(Kmd.address .. "/v1/wallet/release", headers(), body, on_success, on_error)
end

-- @Method:
--  Kmd.rename_wallet
--  Rename the underlying wallet to something else.
-- @Input:
--  - body: table {
--    wallet_id: string,
--    wallet_name: string,
--    wallet_password: string
--  }
--  - on_success: function (data) | nil
--  - on_error: function (data) | nil
function Kmd.rename_wallet(body, on_success, on_error)
	http_client.post(Kmd.address .. "/v1/wallet/rename", headers(), body, on_success, on_error)
end

-- @Method:
--  Kmd.renew_wallet
--  Renew a wallet handle token, increasing its expiration duration to its initial value.
-- @Input:
--  - body: table {
--    wallet_handle_token: string
--  }
--  - on_success: function (data) | nil
--  - on_error: function (data) | nil
function Kmd.renew_wallet(body, on_success, on_error)
	http_client.post(Kmd.address .. "/v1/wallet/renew", headers(), body, on_success, on_error)
end

-- @Method:
--  Kmd.list_wallets
--  Lists all of the wallets that kmd is aware of.
-- @Input:
--  - on_success: function (data) | nil
--  - on_error: function (data) | nil
function Kmd.list_wallets(on_success, on_error)
	http_client.get(Kmd.address .. "/v1/wallets", headers(), on_success, on_error)
end

-- @Method:
--  Kmd.versions
--  Retrieves the current version
-- @Input:
--  - on_success: function (data) | nil
--  - on_error: function (data) | nil
function Kmd.versions(on_success, on_error)
	http_client.get(Kmd.address .. "/versions", headers(), on_success, on_error)
end

return Kmd

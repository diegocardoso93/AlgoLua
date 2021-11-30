local WalletClient = require("AlgoLua.WalletConnect.Client")
local Util = require("AlgoLua.WalletConnect.Util")
local widget = require("widget")

local qrnodes = {}
local txtnodes = {}

local function draw_qrcode()
    qrnodes = {}
    qrnodes[#qrnodes+1] = display.newText('Use Algo Wallet to connect', 140, 30)

    local left = 0
    local bottom = 100
    local size = 6
    local rows = WalletClient.qrcode

    for x=0,#rows-1 do
        local row = rows[#rows-x]
        for i = 1, #row do
            local c = row:sub(i, i)
            if c == '#' then
                local rect = display.newRect(left + (i*size), bottom+x*size, size, size)
                rect:setFillColor(1)
                qrnodes[#qrnodes+1] = rect
            end
        end
    end
end

local function draw_connected()
    -- clear qrcode
    for i,node in pairs(qrnodes) do
        display.remove(node)
    end

    display.newText('Connected Wallet: ' .. WalletClient.connection.accounts[1], 140, 30)

    local button_network = widget.newButton({
        left = 300,
        top = 40,
        id = "network",
        label = "Testnet",
        onEvent = function(event)
            local button = event.target
            if ("ended" == event.phase) then
                if button:getLabel() == 'Testnet' then
                    button:setLabel('Mainnet')
                    WalletClient.network = 'mainnet'
                else
                    button:setLabel('Testnet')
                    WalletClient.network = 'testnet'
                end

                WalletClient.get_account(
                    WalletClient.connection.accounts[1],
                    function(account)
                        msg.post("WalletConnect#interface", "draw_balance")
                    end)
            end
        end,
        shape = "roundedRect",
        width = 120,
        height = 30,
        cornerRadius = 2,
        fillColor = { default={1,0,0,1}, over={1,0.1,0.7,0.4} },
        strokeColor = { default={1,0.4,0,1}, over={0.8,0.8,1,1} },
        strokeWidth = 2
    })

end

local function draw_balance()
    -- clear balance text
    for i,node in pairs(txtnodes) do
        display.remove(node)
    end

    txtnodes = {}
    txtnodes[#txtnodes+1] = display.newText('Balances', 140, 60)

    local assets = WalletClient.account.balance
    for i,asset in pairs(assets) do
        txtnodes[#txtnodes+1] = display.newText(asset['name'], 60, 60+(i*30))
        txtnodes[#txtnodes+1] = display.newText(Util.format_coin(tostring(asset['amount']), '.', asset['decimals']) .. ' ' .. asset['unit-name'], 180, 60+(i*30))
    end
end

local msg = {
    post = function(id, type)
        if id == 'WalletConnect#interface' then
            if type == 'draw_qrcode' then
                draw_qrcode()
            elseif type == 'draw_connected' then
                draw_connected()
            elseif type == 'draw_balance' then
                draw_balance()
            end
        end
    end
}

return msg

--[[ This script should work for Kiddions and YimMenu ]]

do
    local a = {
        transactions = {
            -- { DisplayName, Hash, Value }
            {"15M (Bend Job)", 0x176D9D54, 15000000},
            {"15M (Bend Bonus)", 0xA174F633, 15000000},
            {"15M (Criminal Mastermind)", 0x3EBB7442, 15000000},
            {"15M (Gangpos Mastermind)", 0x23F59C7C, 15000000},
            {"7M (Gang)", 0xED97AFC1, 7000000},
            {"3.6M (Casino Heist)", 0xB703ED29, 3619000},
            {"3M (Agency Story)", 0xBD0D94E3, 3000000},
            {"3M (Gangpos Mastermind)", 0x370A42A5, 3000000},
            {"2.5M (Gang)", 0x46521174, 2550000},
            {"2.5M (Island Heist)", 0xDBF39508, 2550000},
            {"2M (Gangpos Award Order)", 0x32537662, 2000000},
            {"2M (Heist Awards)", 0x8107BB89, 2000000},
            {"2M (Tuner Robbery)", 0x921FCF3C, 2000000},
            {"2M (Business Hub)", 0x4B6A869C, 2000000},
            {"1.5M (Gangpos Loyal Award)", 0x33E1D8F6, 1500000},
            {"1.2M (Boss Agency)", 0xCCFA52D, 1200000},
            {"1M (Music Trip)", 0xDF314B5A, 1000000},
            {"1M (Daily Objective Event)", 0x314FB8B0, 1000000},
            {"1M (Daily Objective)", 0xBFCBE6B6, 1000000},
            {"1M (Juggalo Story Award)", 0x615762F1, 1000000},
            {"700K (Gangpos Loyal Award)", 0xED74CC1D, 700000},
            {"680K (Betting)", 0xACA75AAE, 680000},
            {"620K (Vehicle Export)", 0xEE884170, 620000},
            {"500K (Casino Straight Flush)", 0x059E889DD, 500000},
            {"500K (Juggalo Story)", 0x05F2B7EE, 500000},
            {"400K (Cayo Heist Award Professional)", 0xAC7144BC, 400000},
            {"400K (Cayo Heist Award Cat Burglar)", 0xB4CA7969, 400000},
            {"400K (Cayo Heist Award Elite Thief)", 0xF5AAD2DE, 400000},
            {"400K (Cayo Heist Award Island Thief)", 0x1868FE18, 400000},
            {"350K (Casino Heist Award Elite Thief)", 0x7954FD0F, 350000},
            {"300K (Casino Heist Award All Rounder)", 0x234B8864, 300000},
            {"300K (Casino Heist Award Pro Thief)", 0x2EC48716, 300000},
            {"300K (Ambient Job Blast)", 0xC94D30CC, 300000},
            {"300K (Premium Job)", 0xFD2A7DE7, 300000},
            {"270K (Smuggler Agency)", 0x1B9AFE05, 270000},
            {"250K (Casino Heist Award Professional)", 0x5D7FD908, 250000},
            {"250K (Fixer Award Agency Story)", 0x87356274, 250000},
            {"200K (DoomsDay Finale Bonus)", 0x9145F938, 200000},
            {"200K (Action Figures)", 0xCDCF2380, 200000},
            {"190K (Vehicle Sales)", 0xFD389995, 190000},
            {"180K (Jobs)", -0x3D3A1CC7, 180000}
        },

        b = 4537212,

        loopEnabled = false,
        transaction = 20,

        delay = 200,

        lock = false
    }

    a.triggerTransaction = function(hash, value)
        if hash == nil or value == nil then
            return
        end
        globals.set_int(a.b + 1, 2147483646)
        globals.set_int(a.b + 7, 2147483647)
        globals.set_int(a.b + 6, 0)
        globals.set_int(a.b + 5, 0)
        globals.set_int(a.b + 3, hash)
        globals.set_int(a.b + 2, value)
        globals.set_int(a.b, 2)
    end

    a.cleanupTransaction = function()
        globals.set_int(a.b + 1, 2147483646)
        globals.set_int(a.b + 7, 2147483647)
        globals.set_int(a.b + 6, 0)
        globals.set_int(a.b + 5, 0)
        globals.set_int(a.b + 3, 0)
        globals.set_int(a.b + 2, 0)
        globals.set_int(a.b, 16)
    end

    if require_game_build ~= nil and menu ~= nil and menu["add_submenu"] ~= nil and sleep ~= nil then
        --[[ Kiddions part ]]

        local tab = menu.add_submenu("OP Recovery")

        do
            local state = false
            local loop = function()
                local transaction = a.transactions[20]
                local hash = transaction[2]
                local value = transaction[3]

                while state do
                    a.triggerTransaction(hash, value)
                    sleep(200 / 1000)
                end
            end

            tab:add_toggle("$1m loop",
                function() -- Getter
                    return state
                end,
                function(newstate) -- Setter
                    state = newstate
                    if state then
                        coroutine.resume(coroutine.create(loop))
                    end
                end)
        end

        do
            local manualTransactions = tab:add_submenu("Manual transactions")

            for k, v in pairs(a.transactions) do
                manualTransactions:add_action(v[1], function()
                    if a.lock then
                        return
                    end
                    a.lock = true
                    a.triggerTransaction(v[2], v[3])
                    sleep(5 / 1000)
                    a.lock = false
                end)
            end
        end

    elseif script ~= nil and script["run_in_fiber"] ~= nil and gui ~= nil and gui["get_tab"] ~= nil and ImGui ~= nil then
        --[[ YimMenu part ]]


        
        a.render = function()
            do
                local enabled, toggled = ImGui.Checkbox("$1m loop", a.loopEnabled)
                if toggled then
                    a.loopEnabled = enabled
                    if not enabled then
                        a.cleanupTransaction()
                    end
                end

                ImGui.PushItemWidth(160)
                do
                    local value, used = ImGui.InputInt("Delay in miliseconds", a.delay)
                    if used and value >= 1 and value <= 10000000 then
                        a.delay = value
                    end
                end
                ImGui.PopItemWidth()
            end

            ImGui.Spacing()
            ImGui.Separator()
            ImGui.Spacing()

            do
                ImGui.PushItemWidth(340)
                if ImGui.BeginCombo("##transactions", a.transactions[a.transaction][1]) then
                    for k, v in pairs(a.transactions) do
                        if ImGui.Selectable(v[1], false) then
                            a.transaction = k
                        end
                    end
                    ImGui.EndCombo()
                end
                ImGui.PopItemWidth()

                ImGui.SameLine()

                if ImGui.Button("Trigger transaction") then
                    script.run_in_fiber(function(rs)
                        local transaction = a.transactions[a.transaction]
                        if transaction == nil then return end
                        a.triggerTransaction(transaction[2], transaction[3])
                        rs:sleep(5)
                        a.cleanupTransaction()
                    end)
                end
            end
        end

        gui.get_tab("OP Recovery"):add_imgui(a.render)

        script.run_in_fiber(function(rs)
            local transaction = a.transactions[20]
            local hash = transaction[2]
            local value = transaction[3]

            while true do
                if a.loopEnabled then
                    a.triggerTransaction(hash, value)
                end
                rs:sleep(a.delay)
            end
        end)
    end

    return a
end

OP_Recovery_gui:add_text("Do not spam these transactions, many have cooldowns")

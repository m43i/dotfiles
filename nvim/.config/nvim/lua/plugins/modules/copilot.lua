return {
    -- "zbirenbaum/copilot-cmp",
    "zbirenbaum/copilot.lua",
	-- dependencies = {
	--    },
    config = function ()
		require("copilot").setup({
            panel = { enable = false },
            suggestion = { enabled = false },
        })
        -- require("copilot_cmp").setup()
    end
}

return {
  -- You can also add new plugins here as well:
  -- Add plugins, the lazy syntax
  -- "andweeb/presence.nvim",
  -- {
  --   "ray-x/lsp_signature.nvim",
  --   event = "BufRead",
  --   config = function()
  --     require("lsp_signature").setup()
  --   end,
  -- },
  -- "github/copilot.vim",
  --{
  --    "github/copilot.vim",
  --    as = "copilot",
  --    config = function()
  --      require("copilot").setup {}
  --    end,
  --},
	{
  	"zbirenbaum/copilot.lua",
  	cmd = "Copilot",
  	event = "InsertEnter",
  	config = function()
    	require("copilot").setup({
    		suggestion = {
					enabled = true,
					auto_trigger = true,
					keymap = {
						accept = "<M-l>", -- Alt-l
						dismiss = "<C-]", -- Ctrl-]
						next = "<M-]>",
						prev = "<M-[>",
						accept_word = false,
						accept_line = false,
					}
    		},
    		filetypes = {
    			shell = true,
    			python = true,
    			lua = true,
    			gitcommit = true,
    			gitrebase = true,
    			markdown = true,
    			yaml = true,
    			["."] = false,  -- Trigger on all filetypes
    		}
    	})
  	end,
	}
}

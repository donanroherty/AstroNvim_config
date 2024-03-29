--              AstroNvim Configuration Table
-- All configuration changes should go inside of the table below

require("user.reload")

local config = {
	-- Configure AstroNvim updates
	updater = {
		remote = "origin", -- remote to use
		channel = "stable", -- "stable" or "nightly"
		version = "latest", -- "latest", tag name, or regex search like "v1.*" to only do updates before v2 (STABLE ONLY)
		branch = "main", -- branch name (NIGHTLY ONLY)
		commit = nil, -- commit hash (NIGHTLY ONLY)
		pin_plugins = nil, -- nil, true, false (nil will pin plugins on stable only)
		skip_prompts = false, -- skip prompts about breaking changes
		show_changelog = true, -- show the changelog after performing an update
		auto_reload = false, -- automatically reload and sync packer after a successful update
		auto_quit = false, -- automatically quit the current session after a successful update
		-- remotes = { -- easily add new remotes to track
		--   ["remote_name"] = "https://remote_url.come/repo.git", -- full remote url
		--   ["remote2"] = "github_user/repo", -- GitHub user/repo shortcut,
		--   ["remote3"] = "github_user", -- GitHub user assume AstroNvim fork
		-- },
	},
	-- Set colorscheme to use
	colorscheme = "default_theme",
	-- Add highlight groups in any theme
	highlights = {
		-- init = { -- this table overrides highlights in all themes
		--   Normal = { bg = "#000000" },
		-- }
		-- duskfox = { -- a table of overrides/changes to the duskfox theme
		--   Normal = { bg = "#000000" },
		-- },
	},
	-- set vim options here (vim.<first_key>.<second_key> = value)
	options = {
		opt = {
			-- set to true or false etc.
			relativenumber = true, -- sets vim.opt.relativenumber
			number = true, -- sets vim.opt.number
			spell = false, -- sets vim.opt.spell
			signcolumn = "auto", -- sets vim.opt.signcolumn to auto
			wrap = false, -- sets vim.opt.wrap
		},
		g = {
			mapleader = " ", -- sets vim.g.mapleader
			autoformat_enabled = true, -- enable or disable auto formatting at start (lsp.formatting.format_on_save must be enabled)
			cmp_enabled = true, -- enable completion at start
			autopairs_enabled = true, -- enable autopairs at start
			diagnostics_enabled = true, -- enable diagnostics at start
			status_diagnostics_enabled = true, -- enable diagnostics in statusline
			icons_enabled = true, -- disable icons in the UI (disable if no nerd font is available, requires :PackerSync after changing)
			ui_notifications_enabled = true, -- disable notifications when toggling UI elements
			heirline_bufferline = false, -- enable new heirline based bufferline (requires :PackerSync after changing)
			vimwiki_list = { { path = "~/", syntax = "markdown", ext = ".md" } },
			vimwiki_ext2syntax = {
				[".md"] = "markdown",
				[".markdown"] = "markdown",
				[".mdown"] = "markdown",
			},
		},
	},
	-- If you need more control, you can use the function()...end notation
	-- options = function(local_vim)
	--   local_vim.opt.relativenumber = true
	--   local_vim.g.mapleader = " "
	--   local_vim.opt.whichwrap = vim.opt.whichwrap - { 'b', 's' } -- removing option from list
	--   local_vim.opt.shortmess = vim.opt.shortmess + { I = true } -- add to option list
	--
	--   return local_vim
	-- end,

	-- Set dashboard header
	header = {
		" █████  ███████ ████████ ██████   ██████",
		"██   ██ ██         ██    ██   ██ ██    ██",
		"███████ ███████    ██    ██████  ██    ██",
		"██   ██      ██    ██    ██   ██ ██    ██",
		"██   ██ ███████    ██    ██   ██  ██████",
		" ",
		"    ███    ██ ██    ██ ██ ███    ███",
		"    ████   ██ ██    ██ ██ ████  ████",
		"    ██ ██  ██ ██    ██ ██ ██ ████ ██",
		"    ██  ██ ██  ██  ██  ██ ██  ██  ██",
		"    ██   ████   ████   ██ ██      ██",
	},
	-- Default theme configuration
	default_theme = {
		colors = {
			fg = "#abb2bf",
			bg = "#1e222a",
		},
		highlights = function(hl) -- or a function that returns a new table of colors to set
			local C = require("default_theme.colors")

			hl.Normal = { fg = C.fg, bg = C.bg }

			-- New approach instead of diagnostic_style
			hl.DiagnosticError.italic = true
			hl.DiagnosticHint.italic = true
			hl.DiagnosticInfo.italic = true
			hl.DiagnosticWarn.italic = true

			return hl
		end,
		-- enable or disable highlighting for extra plugins
		plugins = {
			aerial = true,
			beacon = false,
			bufferline = true,
			cmp = true,
			dashboard = true,
			highlighturl = true,
			hop = false,
			indent_blankline = true,
			lightspeed = false,
			["neo-tree"] = true,
			notify = true,
			["nvim-tree"] = false,
			["nvim-web-devicons"] = true,
			rainbow = true,
			symbols_outline = false,
			telescope = true,
			treesitter = true,
			vimwiki = false,
			["which-key"] = true,
		},
	},
	-- Diagnostics configuration (for vim.diagnostics.config({...})) when diagnostics are on
	diagnostics = {
		virtual_text = true,
		underline = true,
	},
	-- Extend LSP configuration
	lsp = {
		-- enable servers that you already have installed without mason
		servers = {
			-- "pyright"
		},
		formatting = {
			-- control auto formatting on save
			format_on_save = {
				enabled = true, -- enable or disable format on save globally
				allow_filetypes = { -- enable format on save for specified filetypes only
					-- "go",
				},
				ignore_filetypes = { -- disable format on save for specified filetypes
					-- "python",
				},
			},
			disabled = { -- disable formatting capabilities for the listed language servers
				-- "sumneko_lua",
			},
			timeout_ms = 1000, -- default format timeout
			-- filter = function(client) -- fully override the default formatting function
			--   return true
			-- end
		},
		-- easily add or disable built in mappings added during LSP attaching
		mappings = {
			n = {
				-- ["<leader>lf"] = false -- disable formatting keymap
			},
			i = {},
		},
		-- add to the global LSP on_attach function
		-- on_attach = function(client, bufnr)
		-- end,

		-- override the mason server-registration function
		server_registration = function(server, opts)
			require("lspconfig")[server].setup(opts)
			if server == "rust_analyzer" then
				require("rust-tools").setup({ server = opts })
				return
			end
		end,
		-- Add overrides for LSP server settings, the keys are the name of the server
		["server-settings"] = {
			-- example for addings schemas to yamlls
			-- yamlls = { -- override table for require("lspconfig").yamlls.setup({...})
			--   settings = {
			--     yaml = {
			--       schemas = {
			--         ["http://json.schemastore.org/github-workflow"] = ".github/workflows/*.{yml,yaml}",
			--         ["http://json.schemastore.org/github-action"] = ".github/action.{yml,yaml}",
			--         ["http://json.schemastore.org/ansible-stable-2.9"] = "roles/tasks/*.{yml,yaml}",
			--       },
			--     },
			--   },
			-- },
		},
	},
	-- Mapping data with "desc" stored directly by vim.keymap.set().
	mappings = {
		-- normal mode
		n = {
			-- buffer
			["<leader>bb"] = { "<cmd>tabnew<cr>", desc = "New tab" },
			["<leader>bc"] = { "<cmd>BufferLinePickClose<cr>", desc = "Pick to close" },
			["<leader>bj"] = { "<cmd>BufferLinePick<cr>", desc = "Pick to jump" },
			["<leader>bt"] = { "<cmd>BufferLineSortByTabs<cr>", desc = "Sort by tabs" },
			-- lazygit
			["<leader>gg"] = {
				function()
					astronvim.toggle_term_cmd({ cmd = "lazygit", direction = "float", count = 5 })
				end,
				desc = "ToggleTerm lazygit",
			},
			["<leader>tl"] = {
				function()
					astronvim.toggle_term_cmd({ cmd = "lazygit", direction = "float", count = 5 })
				end,
				desc = "ToggleTerm lazygit",
			},
			-- git tree
			["<leader>gva"] = { "<cmd>GV<cr>", desc = "Git tree for all changes" },
			["<leader>gvf"] = { "<cmd>GV!<cr>", desc = "Git tree for current file" },
			-- config
			["<leader>;r"] = { "<cmd>lua ReloadConfig()<CR>", desc = "Reload config" },
			["<leader>;u"] = { "<cmd> e ~/.config/nvim/lua/user/init.lua<CR>", desc = "Open user config" },
			["<leader>;d"] = { "<cmd> Ex ~/.config/nvim/lua/user/<CR>", desc = "Open user config directory" },
			-- split size
			["<C-Up>"] = { "<cmd>resize -2<CR>", desc = "Resize split up" },
			["<C-Down>"] = { "<cmd>resize +2<CR>", desc = "Resize split down" },
			["<C-Left>"] = { "<cmd>vertical resize -2<CR>", desc = "Resize split left" },
			["<C-Right>"] = { "<cmd>vertical resize +2<CR>", desc = "Resize split right" },
			-- undo tree
			["<leader><F5>"] = { "<cmd> lua vim.cmd.UndotreeToggle() <CR>", desc = "Undo tree" },
			-- trouble
			["<leader>lt"] = { "<cmd> lua vim.diagnostic.open_float() <CR>", desc = "? toggles local troubleshoot" },
		},
		t = {
			-- setting a mapping to false will disable it
			-- ["<esc>"] = false,
		},
	},
	-- Configure plugins
	plugins = {
		init = {
			{
				"ray-x/lsp_signature.nvim",
				event = "BufRead",
				config = function()
					require("lsp_signature").setup()
				end,
			},

			{
				"zbirenbaum/copilot.lua",
				require("copilot").setup({
					panel = {
						-- enabled = false,
						auto_refresh = false,
						keymap = {
							accept = "<CR>",
							jump_prev = "[[",
							jump_next = "]]",
							refresh = "gr",
							open = "<M-CR>",
						},
					},
					suggestion = {
						-- enabled = false,
						auto_trigger = true,
						keymap = {
							accept = "<M-l>",
							prev = "<M-[>",
							next = "<M-]>",
							dismiss = "<C-]>",
						},
					},
				}),
			},

			{
				"zbirenbaum/copilot-cmp",
				after = { "copilot.lua" },
				config = function()
					require("copilot_cmp").setup({
						formatters = {
							label = require("copilot_cmp.format").format_label_text,
							insert_text = require("copilot_cmp.format").format_insert_text,
							preview = require("copilot_cmp.format").deindent,
						},
					})
				end,
			},

			{
				"vimwiki/vimwiki",
			},

			{
				"karb94/neoscroll.nvim",
				require("neoscroll").setup({
					mappings = {
						"<C-u>",
						"<C-d>",
						"<C-b>",
						"<C-f>",
						"<C-y>",
						"<C-e>",
						"zt",
						"zz",
						"zb",
					},
					hide_cursor = true, -- Hide cursor while scrolling
					stop_eof = true, -- Stop at <EOF> when scrolling downwards
					respect_scrolloff = false, -- Stop scrolling when the cursor reaches the scrolloff margin of the file
					cursor_scrolls_alone = true, -- The cursor will keep on scrolling even if the window cannot scroll further
					easing_function = nil, -- Default easing function
					pre_hook = nil, -- Function to run before the scrolling animation starts
					post_hook = nil, -- Function to run after the scrolling animation ends
					performance_mode = false, -- Disable "Performance Mode" on all buffers.
				}),
			},

			{
				"tpope/vim-fugitive",
			},

			{
				"junegunn/gv.vim",
			},

			{
				"simrat39/rust-tools.nvim",
				as = "rust-tools",
				config = function()
					require("rust-tools").setup({})
				end,
			},

			{
				"nvim-neotest/neotest",
				requires = {
					"nvim-lua/plenary.nvim",
					"nvim-treesitter/nvim-treesitter",
					"antoinemadec/FixCursorHold.nvim",
					"nvim-neotest/neotest-go",
					"marilari88/neotest-vitest",
					"haydenmeade/neotest-jest",
				},
				config = function()
					-- get neotest namespace (api call creates or returns namespace)
					local neotest_ns = vim.api.nvim_create_namespace("neotest")
					vim.diagnostic.config({
						virtual_text = {
							format = function(diagnostic)
								local message =
									diagnostic.message:gsub("\n", " "):gsub("\t", " "):gsub("%s+", " "):gsub("^%s+", "")
								return message
							end,
						},
					}, neotest_ns)
					require("neotest").setup({
						adapters = {
							require("neotest-go"),
							require("neotest-deno"),
							require("neotest-rust"),
							require("neotest-vitest"),
							require("neotest-vim-test"),
							require("neotest-jest")({
								jestCommand = "jest --watch ",
								jestConfigFile = "custom.jest.config.ts",
								env = { CI = true },
								cwd = function(path)
									return vim.fn.getcwd()
								end,
							}),
						},
					})
				end,
			},

			{
				"justinmk/vim-sneak",
			},

			{
				"mbbill/undotree",
			},

			{
				"ekalinin/Dockerfile.vim",
			},

			{
				"gaoDean/autolist.nvim",
				ft = {
					"markdown",
					"text",
					"tex",
					"plaintex",
				},
				config = function()
					local autolist = require("autolist")
					autolist.setup()
					autolist.create_mapping_hook("i", "<CR>", autolist.new)
					autolist.create_mapping_hook("i", "<Tab>", autolist.indent)
					autolist.create_mapping_hook("i", "<S-Tab>", autolist.indent, "<C-D>")
					autolist.create_mapping_hook("n", "o", autolist.new)
					autolist.create_mapping_hook("n", "O", autolist.new_before)
					autolist.create_mapping_hook("n", ">>", autolist.indent)
					autolist.create_mapping_hook("n", "<<", autolist.indent)
					autolist.create_mapping_hook("n", "<C-r>", autolist.force_recalculate)
					autolist.create_mapping_hook("n", "<leader>x", autolist.invert_entry, "")
				end,
			},

			{
				"iamcco/markdown-preview.nvim",
				run = "cd app && npm install",
				setup = function()
					vim.g.mkdp_filetypes = { "markdown" }
				end,
				ft = { "markdown" },
			},
		},
		-- All other entries override the require("<key>").setup({...}) call for default plugins
		["null-ls"] = function(config) -- overrides `require("null-ls").setup(config)`
			-- config variable is the default configuration table for the setup function call
			-- local null_ls = require "null-ls"

			-- Check supported formatters and linters
			-- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/formatting
			-- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/diagnostics
			config.sources = {
				-- Set a formatter
				-- null_ls.builtins.formatting.stylua,
				-- null_ls.builtins.formatting.prettier,
			}
			return config -- return final config table
		end,
		treesitter = { -- overrides `require("treesitter").setup(...)`
			-- ensure_installed = { "lua" },
		},
		-- use mason-lspconfig to configure LSP installations
		["mason-lspconfig"] = { -- overrides `require("mason-lspconfig").setup(...)`
			ensure_installed = { "sumneko_lua" },
		},
		-- use mason-null-ls to configure Formatters/Linter installation for null-ls sources
		["mason-null-ls"] = { -- overrides `require("mason-null-ls").setup(...)`
			ensure_installed = { "prettier", "stylua" },
		},
		["mason-nvim-dap"] = { -- overrides `require("mason-nvim-dap").setup(...)`
			ensure_installed = { "python", "rust" },
		},
		["neo-tree"] = {
			filesystem = {
				filtered_items = {
					visible = true,
					hide_dotfiles = false,
					hide_gitignored = true,
				},
			},
		},
		["telescope"] = {
			pickers = {
				find_files = {
					hidden = true,
				},
			},
		},
		["toggleterm"] = {
			direction = "horizontal",
		},
		["indent-o-matic"] = {
			standard_widths = { 2 },
		},
		["nvim-cmp"] = {
			sources = {
				{ name = "copilot", group_index = 2 },
			},
		},
	},
	-- LuaSnip Options
	luasnip = {
		-- Extend filetypes
		filetype_extend = {
			-- javascript = { "javascriptreact" },
		},
		-- Configure luasnip loaders (vscode, lua, and/or snipmate)
		vscode = {
			-- Add paths for including more VS Code style snippets in luasnip
			paths = {},
		},
	},
	-- CMP Source Priorities
	-- modify here the priorities of default cmp sources
	-- higher value == higher priority
	-- The value can also be set to a boolean for disabling default sources:
	-- false == disabled
	-- true == 1000
	cmp = {
		source_priority = {
			copilot = 1500,
			nvim_lsp = 1000,
			luasnip = 750,
			buffer = 500,
			path = 250,
		},
	},
	-- Customize Heirline options
	heirline = {
		-- -- Customize different separators between sections
		-- separators = {
		--   tab = { "", "" },
		-- },
		-- -- Customize colors for each element each element has a `_fg` and a `_bg`
		-- colors = function(colors)
		--   colors.git_branch_fg = astronvim.get_hlgroup "Conditional"
		--   return colors
		-- end,
		-- -- Customize attributes of highlighting in Heirline components
		-- attributes = {
		--   -- styling choices for each heirline element, check possible attributes with `:h attr-list`
		--   git_branch = { bold = true }, -- bold the git branch statusline component
		-- },
		-- -- Customize if icons should be highlighted
		-- icon_highlights = {
		--   breadcrumbs = false, -- LSP symbols in the breadcrumbs
		--   file_icon = {
		--     winbar = false, -- Filetype icon in the winbar inactive windows
		--     statusline = true, -- Filetype icon in the statusline
		--   },
		-- },
	},
	-- Modify which-key registration (Use this with mappings table in the above.)
	["which-key"] = {
		-- Add bindings which show up as group name
		register = {
			-- first key is the mode, n == normal mode
			n = {
				-- second key is the prefix, <leader> prefixes
				["<leader>"] = {
					-- third key is the key to bring up next level and its displayed
					-- group name in which-key top level menu
					["b"] = { name = "Buffer" },
				},
			},
		},
	},
	-- This function is run last and is a good place to configuring
	-- autogroups/autocommands and custom filetypes also this just pure lua so
	-- anything that doesn't fit in the normal config locations above can go here
	polish = function()
		-- Set up custom filetypes
		-- vim.filetype.add {
		--   extension = {
		--     foo = "fooscript",
		--   },
		--   filename = {
		--     ["Foofile"] = "fooscript",
		--   },
		--   pattern = {
		--     ["~/%.config/foo/.*"] = "fooscript",
		--   },
		-- }

		if vim.fn.filereadable(".vscode/launch.json") then
			require("dap.ext.vscode").load_launchjs()
		end

		local rt = require("rust-tools")
		rt.setup({
			server = {
				on_attach = function(_, bufnr)
					-- Hover actions
					vim.keymap.set("n", "<C-space>", rt.hover_actions.hover_actions, { buffer = bufnr })
					-- Code action groups
					vim.keymap.set("n", "<Leader>a", rt.code_action_group.code_action_group, { buffer = bufnr })
				end,
			},
		})
	end,
}

return config

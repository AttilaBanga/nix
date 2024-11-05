local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)
vim.g.mapleader = " "
local home = os.getenv("HOME")

local plugins = {
    'mfussenegger/nvim-jdtls',
    'nvim-tree/nvim-web-devicons',
    'nvim-telescope/telescope-symbols.nvim',
    {
    'nvim-telescope/telescope.nvim',
        tag = '0.1.6',
        dependencies = { 'nvim-lua/plenary.nvim' }
    },
    'mfussenegger/nvim-dap',
    'neovim/nvim-lspconfig',
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-path',
    'hrsh7th/cmp-cmdline',
    'saadparwaiz1/cmp_luasnip',
    'leoluz/nvim-dap-go',
    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            {
                "MattiasMTS/cmp-dbee",
                dependencies = {
                    {"kndndrj/nvim-dbee"}
                },
                ft = "sql", -- optional but good to have
                opts = {}, -- needed
                config = function()
                    require("cmp-dbee").setup({})
                end
            },
            "saadparwaiz1/cmp_luasnip",
        },
--        opts = {
--            sources = {
--                { "cmp-dbee" },
--            },
--        },
        opts = function(_, opts)
            local cmp = require("cmp")
            local luasnip = require("luasnip")
            -- require("luasnip.loaders.from_vscode").lazy_load()
            opts.snippet = {
                expand = function(args)
                    require("luasnip").lsp_expand(args.body)
                end,
            }
            opts.window = {}
            opts.sources = {}
            table.insert(opts.sources, { name = "luasnip" })
            table.insert(opts.sources, { name = "cmp-dbee" })
            table.insert(opts.sources, { name = "nvim_lsp" })
            table.insert(opts.sources, { name = "buffer" })
            opts.mapping = cmp.mapping.preset.insert({
                ['<CR>'] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        if luasnip.expandable() then
                            luasnip.expand()
                        else
                            cmp.confirm({
                                select = true,
                            })
                        end
                    else
                        fallback()
                    end
                end),

                ["<Tab>"] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_next_item()
                    elseif luasnip.locally_jumpable(1) then
                        luasnip.jump(1)
                    else
                        fallback()
                    end
                end, { "i", "s" }),

                ["<S-Tab>"] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_prev_item()
                    elseif luasnip.locally_jumpable(-1) then
                        luasnip.jump(-1)
                    else
                        fallback()
                    end
                end, { "i", "s" }),
            })
        end,
    },
    { "catppuccin/nvim", name = "catppuccin", priority = 1000 },
    {
        "kdheepak/lazygit.nvim",
        requires = {
            "nvim-lua/plenary.nvim",
        },
    },
    {
        "nvim-treesitter/nvim-treesitter", 
        build = ":TSUpdate",
        config = function () 
            local configs = require("nvim-treesitter.configs")

            configs.setup({
                ensure_installed = { "lua", "vimdoc", "query", "javascript", "html" ,"java", "php", "go", "sql"},
                sync_install = true,
                auto_install = false,
                highlight = { enable = true },
                --indent = { enable = true },  
            })
        end
    },
    {
	    "L3MON4D3/LuaSnip",
	    -- follow latest release.
	    version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
	    -- install jsregexp (optional!).
	    build = "make install_jsregexp",
        config = function ()
            require("luasnip.loaders.from_lua").load({paths = "~/.config/nvim/snippets"})
        end,
        keys = {
            { "<C-j>", "<Plug>luasnip-next-choice", mode = {"i", "s"}},
            { "<C-k>", "<Plug>luasnip-prev-choice", mode = {"i", "s"}},
            { "<C-s>", function () require("luasnip.extras.select_choice")() end, mode = {"i", "s"}},
        }
    },
    {
        "kndndrj/nvim-dbee",
        dependencies = {
            "MunifTanjim/nui.nvim",
        },
        build = function()
            -- Install tries to automatically detect the install method.
            -- if it fails, try calling it with one of these parameters:
            --    "curl", "wget", "bitsadmin", "go"
            require("dbee").install()
        end,
        config = function()
            require("dbee").setup({
                extra_helpers = {
                    ["mysql"] = {
                        ["List"] = "select * from {{ .Table }} order by id desc limit 100",
                    },
                    ["postgres"] = {
                        ["List"] = "select * from {{ .Table }} order by id desc limit 100",
                    },
                }
        })
        end,
    },
    {
        "nvim-neotest/neotest",
        dependencies = {
            "nvim-neotest/nvim-nio",
            "nvim-lua/plenary.nvim",
            "antoinemadec/FixCursorHold.nvim",
            "nvim-treesitter/nvim-treesitter",
            "nvim-neotest/neotest-go",
            --"fredrikaverpil/neotest-golang",
            "rcasia/neotest-java",
            "olimorris/neotest-phpunit",
        },
        config = function()
            require('dap').adapters.php = {
                type = 'executable',
                command = 'node',
                args = { home .. "/language_servers/vscode-php-debug/out/phpDebug.js" },
            }

            require('dap').configurations.php = {
                {
                    log = true,
                    type = 'php',
                    request = 'launch',
                    name = 'Listen for xdebug',
                    --        hostname = '0.0.0.0',
                    port = 9003,
                    stopOnEntry = false,
                    xdebugSettings = {
                        max_children = 512,
                        max_data = 1024,
                        max_depth = 4,
                    },
                    breakpoints = {
                        exception = {
                            Notice = false,
                            Warning = false,
                            Error = false,
                            Exception = false,
                            ["*"] = false,
                        },
                            },
            --        serverSourceRoot = '/var/www/html',
            --        localSourceRoot = home .. '/workspace/digiloop/package-points-installer'
            --        localSourceRoot = home .. '/workspace/digiloop/package-points-backend'
            --        localSourceRoot = home .. '/workspace/digiloop/invoice-backend'
                    localSourceRoot = home .. '/PhpstormProjects/syncee-backend'
                }
            }
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
                -- your neotest config here
                adapters = {
--                    require("neotest-golang")({
--                        go_test_args = {
--                            "-v",
--                            "-race",
--                        },
--                        dap_go_enabled = true,
--                    }),
                    require("neotest-go")({
                        experimental = {
                            test_table = true,
                        },
                        args = { "-v", "-race", "-timeout=60s" }
                    }),
                    require("neotest-java")({
                        ignore_wrapper = true,
                    }),
                    require("neotest-phpunit")({
                        env = {
                            XDEBUG_CONFIG = "idekey=neotest",
                        },
                        dap = require('dap').configurations.php[1],
                    }),
                },
            })
        end,
        keys = {
            { "<leader>t",  function() require("neotest").run.run() end,                     mode = { "n" } },
            { "<leader>tt", function() require("neotest").run.stop() end, desc = "[t]est [t]erminate" },
            { "<leader>T",  function() require("neotest").run.run(vim.fn.expand("%")) end,   mode = { "n" } },
            { "<leader>td", function() require("neotest").run.run({ strategy = "dap" }) end, mode = { "n" } },
            { "<leader>ts", function() require("neotest").run.stop() end,                    mode = { "n" } },
            { "<leader>ts", function() require("neotest").summary.toggle() end, desc = "[t]est [s]ummary" },
            { "<leader>to", function() require("neotest").output.open({ enter = true, auto_close = true }) end, desc = "[t]est [o]utput" },
            { "<leader>tO", function() require("neotest").output_panel.toggle() end, desc = "[t]est [O]utput panel" },
        }
    }
}

local opts = {
	lockfile = os.getenv("LAZY_LOCK")
}

require("lazy").setup(plugins, opts)

require("azridum");

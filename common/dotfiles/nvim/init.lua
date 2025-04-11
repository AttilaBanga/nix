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
--vim.g.neotest_log_level = vim.log.levels.DEBUG

local plugins = {
    'mfussenegger/nvim-jdtls',
    'nvim-tree/nvim-web-devicons',
    'nvim-telescope/telescope-symbols.nvim',
    {
        'nvim-telescope/telescope.nvim',
        tag = '0.1.6',
        dependencies = { 'nvim-lua/plenary.nvim' }
    },
    'neovim/nvim-lspconfig',
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-path',
    'hrsh7th/cmp-cmdline',
    'saadparwaiz1/cmp_luasnip',
    'leoluz/nvim-dap-go',
    { "rcarriga/nvim-dap-ui", dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" } },
    'theHamsta/nvim-dap-virtual-text',
    {
        "folke/lazydev.nvim",
        ft = "lua", -- only load on lua files
        opts = {
            library = {
                -- See the configuration section for more details
                -- Load luvit types when the `vim.uv` word is found
                { path = "${3rd}/luv/library", words = { "vim%.uv" } },
            },
        },
    },
    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            {
                "MattiasMTS/cmp-dbee",
                dependencies = {
                    { "kndndrj/nvim-dbee" }
                },
                ft = "sql", -- optional but good to have
                opts = {},  -- needed
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
            require("nvim-dap-virtual-text").setup()
            require("lazydev").setup({
                library = { "nvim-dap-ui" },
            })
            require("dapui").setup()
            local dap, dapui = require("dap"), require("dapui")
            dap.listeners.before.attach.dapui_config = function()
                dapui.open()
            end
            dap.listeners.before.launch.dapui_config = function()
                dapui.open()
            end
            dap.listeners.before.event_terminated.dapui_config = function()
                dapui.close()
            end
            dap.listeners.before.event_exited.dapui_config = function()
                dapui.close()
            end
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
    { "catppuccin/nvim",      name = "catppuccin",                                                priority = 1000 },
    {
        "kdheepak/lazygit.nvim",
        requires = {
            "nvim-lua/plenary.nvim",
        },
    },
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function()
            local configs = require("nvim-treesitter.configs")

            configs.setup({
                ensure_installed = { "lua", "vimdoc", "query", "javascript", "html", "java", "php", "go", "sql" },
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
        config = function()
            require("luasnip.loaders.from_lua").load({ paths = "~/.config/nvim/snippets" })
        end,
        keys = {
            { "<C-j>", "<Plug>luasnip-next-choice",                              mode = { "i", "s" } },
            { "<C-k>", "<Plug>luasnip-prev-choice",                              mode = { "i", "s" } },
            { "<C-s>", function() require("luasnip.extras.select_choice")() end, mode = { "i", "s" } },
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
            --"nvim-neotest/neotest-go",
            "fredrikaverpil/neotest-golang",
            "rcasia/neotest-java",
            "olimorris/neotest-phpunit",
            "nvim-neotest/neotest-plenary",
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
                        local message = diagnostic.message:gsub("\n", " "):gsub("\t", " "):gsub("%s+", " "):gsub("^%s+",
                            "")
                        return message ~= "" and message or nil
                    end,
                },
            }, neotest_ns)
            require("neotest").setup({
                -- your neotest config here
                adapters = {
                    require("neotest-plenary"),
                    require("neotest-golang")({
                        go_test_args = {
                            "-v",
                            "-race",
                            "-coverprofile=" .. vim.fn.getcwd() .. "/coverage.out",
                        },
                        dap_go_enabled = true,
                    }),
                    require("neotest-java")({
                        ignore_wrapper = true,
                        incremental_build = true,
                        classpath = {
                            exclude_source_paths = true,
                        }
                    }),
                    require("neotest-phpunit")({
                        env = {
                            XDEBUG_CONFIG = "idekey=neotest",
                        },
                        dap = require('dap').configurations.php[1],
                    }),
                },
                status = { enabled = true, virtual_text = true, signs = false, },
                output = { enabled = true, open_on_run = true },
                quickfix = {
                    enabled = true,
                    open = function()
                        require("trouble").open({ mode = "quickfix", focus = false })
                    end,
                },
                diagnostic = {
                    enabled = true,
                    severity = vim.diagnostic.severity.ERROR
                },
            })
        end,
        keys = {
            { "<leader>t",  function() require("neotest").run.run() end,                     mode = { "n" } },
            { "<leader>tt", function() require("neotest").run.stop() end,                    desc = "[t]est [t]erminate" },
            { "<leader>T",  function() require("neotest").run.run(vim.fn.expand("%")) end,   mode = { "n" } },
            { "<leader>td", function() require("neotest").run.run({ strategy = "dap" }) end, mode = { "n" } },
            { "<leader>ts", function() require("neotest").run.stop() end,                    mode = { "n" } },
            { "<leader>ts", function() require("neotest").summary.toggle() end,              desc = "[t]est [s]ummary" },
            {
                "<leader>to",
                function()
                    require("neotest").output.open({
                        enter = true,
                    })
                end,
                desc = "[t]est [o]utput"
            },
            { "<leader>tO", function() require("neotest").output_panel.toggle() end, desc = "[t]est [O]utput panel" },
        }
    },
    {
        "nomnivore/ollama.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
        },

        -- All the user commands added by the plugin
        cmd = { "Ollama", "OllamaModel", "OllamaServe", "OllamaServeStop" },

        keys = {
            -- Sample keybind for prompt menu. Note that the <c-u> is important for selections to work properly.
            {
                "<leader>oo",
                ":<c-u>lua require('ollama').prompt()<cr>",
                desc = "ollama prompt",
                mode = { "n", "v" },
            },

            -- Sample keybind for direct prompting. Note that the <c-u> is important for selections to work properly.
            {
                "<leader>oG",
                ":<c-u>lua require('ollama').prompt('Generate_Code')<cr>",
                desc = "ollama Generate Code",
                mode = { "n", "v" },
            },
        },

        ---@type Ollama.Config
        opts = {
            model = "mistral:instruct",
            url = "http://127.0.0.1:11434",
            serve = {
                on_start = false,
                command = "ollama",
                args = { "serve" },
                stop_command = "pkill",
                stop_args = { "-SIGTERM", "ollama" },
            },
            prompts = {
                Do_With_Input = {
                    prompt = "$input ```$sel```",
                    input_label = "> ",
                    action = "display",
                },
            }
        },
    },
    {
        'stevearc/dressing.nvim',
        opts = {},
    },
    {
        "andythigpen/nvim-coverage",
        version = "*",
        config = function()
            require("coverage").setup({
                auto_reload = true,
                summary = {
                    min_coverage = 80.0,
                },
            })
        end,
    },
    'folke/trouble.nvim',
    {
        "ravibrock/spellwarn.nvim",
        event = "VeryLazy",
        config = true,
    },
}

local opts = {
    lockfile = os.getenv("LAZY_LOCK")
}

require("lazy").setup(plugins, opts)
require("spellwarn").setup(
    {
        event = { -- event(s) to refresh diagnostics on
            "CursorHold",
            "InsertLeave",
            "TextChanged",
            "TextChangedI",
            "TextChangedP",
        },
        enable = true, -- enable diagnostics on startup
        ft_config = { -- spellcheck method: "cursor", "iter", or boolean
            alpha   = false,
            help    = false,
            lazy    = false,
            lspinfo = false,
            mason   = false,
        },
        ft_default = true, -- default option for unspecified filetypes
        max_file_size = nil, -- maximum file size to check in lines (nil for no limit)
        severity = {     -- severity for each spelling error type (false to disable diagnostics for that type)
            spellbad   = "WARN",
            spellcap   = "HINT",
            spelllocal = "HINT",
            spellrare  = "INFO",
        },
        prefix = "possible misspelling(s): ",   -- prefix for each diagnostic message
        diagnostic_opts = { severity_sort = true }, -- options for diagnostic display
    }
)

require("azridum");

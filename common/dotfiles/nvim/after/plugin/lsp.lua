local dap = require("dap")
local home = os.getenv("HOME")
local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')
local cmp = require("cmp")
local capabilities = require('cmp_nvim_lsp').default_capabilities()

local php_conf = {
    workspace_folders = {
        {
            name = project_name,
            uri = home .. "/.cache/nvim/workspace/" .. project_name
        }
    },
    capabilities = capabilities
}

require 'lspconfig'.nixd.setup {}

require("lspconfig").intelephense.setup(php_conf)
require 'lspconfig'.tailwindcss.setup {
    capabilities = capabilities,
    filetypes = { "aspnetcorerazor", "astro", "astro-markdown", "blade", "clojure", "django-html", "htmldjango", "edge", "eelixir", "elixir", "ejs", "erb", "eruby", "gohtml", "gohtmltmpl", "haml", "handlebars", "hbs", "html", "htmlangular", "html-eex", "heex", "jade", "leaf", "liquid", "markdown", "mdx", "mustache", "njk", "nunjucks", "php", "razor", "slim", "twig", "css", "less", "postcss", "sass", "scss", "stylus", "sugarss", "javascript", "javascriptreact", "reason", "rescript", "typescript", "typescriptreact", "vue", "svelte", "templ", "rust" },
    settings = {
        tailwindCSS = {
            includeLanguages = {
                rust = "html",
                ["*.rc"] = "html",
            },
        },
        emmet = {
            includeLanguages = {
                rust = "html",
                ["*.rc"] = "html",
            },
        },
        files = {
            associations = {
                ["*.rc"] = "rust",
            },
        },
        editor = {
            quickSuggestions = {
                other = "on",
                comments = "on",
                strings = true,
            },
        },
        css = {
            validate = false,
        },
    },
}
require 'lspconfig'.ts_ls.setup { capabilities = capabilities }
require("lspconfig").rust_analyzer.setup({
    capabilities = capabilities,
    settings = {
        ["rust-analyzer"] = {
            -- Other Settings ...
            procMacro = {
                enable = true,
                ignored = {
                    leptos_macro = {
                        -- optional: --
                        -- "component",
                        "server",
                    },
                },
            },
            rustfmt = {
                overrideCommand = { "leptosfmt", "--stdin", "--rustfmt" },
            },
            cargo = {
                features = {
                    "ssr",
                    "hydrate"
                },
            },
        },
    }
})
require 'lspconfig'.gopls.setup({
    capabilities = capabilities,
    settings = {
        gopls = {
            buildFlags = { "-tags", "wireinject" },
        },
    },
})
require 'lspconfig'.pylsp.setup { capabilities = capabilities }
require 'lspconfig'.terraformls.setup {}

require('lspconfig').yamlls.setup {
    settings = {
        yaml = {
            schemas = {
                ["https://raw.githubusercontent.com/instrumenta/kubernetes-json-schema/master/v1.18.0-standalone-strict/all.json"] = "/*.k8s.yaml",
            },
        },
    }
}

require 'lspconfig'.bufls.setup { capabilities = capabilities }


require('dap-go').setup()

require 'lspconfig'.lua_ls.setup {
    on_init = function(client)
        if client.workspace_folders then
            local path = client.workspace_folders[1].name
            if vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc') then
                return
            end
        end

        client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
            runtime = {
                -- Tell the language server which version of Lua you're using
                -- (most likely LuaJIT in the case of Neovim)
                version = 'LuaJIT'
            },
            -- Make the server aware of Neovim runtime files
            workspace = {
                checkThirdParty = false,
                library = {
                    vim.env.VIMRUNTIME
                    -- Depending on the usage, you might want to add additional paths here.
                    -- "${3rd}/luv/library"
                    -- "${3rd}/busted/library",
                }
                -- or pull in all of 'runtimepath'. NOTE: this is a lot slower and will cause issues when working on your own configuration (see https://github.com/neovim/nvim-lspconfig/issues/3189)
                -- library = vim.api.nvim_get_runtime_file("", true)
            }
        })
    end,
    settings = {
        Lua = {}
    }
}

--dap.configurations.php = {
--    {
--        type = 'php',
--        request = 'launch',
--        name = 'Listen for xdebug',
--        hostname = '0.0.0.0',
--        port = 9001,
--        stopOnEntry = false,
----        serverSourceRoot = '/var/www/html',
----        localSourceRoot = home .. '/workspace/digiloop/invoice-backend'
--    }
--}

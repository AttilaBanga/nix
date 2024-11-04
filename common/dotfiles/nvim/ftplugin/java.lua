local jdtls = require('jdtls')
local home = os.getenv("HOME")
local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')
local dap = require("dap")
local capabilities = require('cmp_nvim_lsp').default_capabilities()
local nnoremap = require("azridum.keymap").nnoremap

local bundles = {
    vim.fn.glob(home .. "/language_servers/java-debug/com.microsoft.java.debug.plugin/target/com.microsoft.java.debug.plugin-*.jar", 1)
}

vim.list_extend(bundles, vim.split(vim.fn.glob(home .. "/language_servers/vscode-java-test/server/*.jar", 1), "\n"))

local formatter_path = vim.fn.getcwd() .. "/format.xml"

local config = {
    cmd = {
        "jdtls",
        --"--jvm-arg=-javaagent:" .. home .. "/.m2/repository/org/projectlombok/lombok/1.18.30/lombok-1.18.30.jar",
        "--jvm-arg=-javaagent:" .. os.getenv("LOMBOK_JAR"),
        "-data", home .. "/.cache/jdtls/workspace/" .. project_name
    },
    init_options = {
        workspace = home .. "/.cache/jdtls/workspace/" .. project_name,
        bundles = bundles
    },
    on_attach = function(client, bufnr)
        jdtls.setup_dap({ 
            hotcodereplace = 'auto',
            require("jdtls.dap").setup_dap_main_class_configs({
                config_overrides = {
                    env = require("envs." .. project_name) 
                }
            })
        })
    end,
    capabilities = capabilities,
    settings = {
        java = {
            format = {
                settings = {
                    url = formatter_path,
                    profile = 'Default'
                }
            }
        }
    }
    --	root_dir = vim.fs.dirname(vim.fs.find({'.gradlew', '.git', 'mvnw'}, { upward = true })[1]),
}

jdtls.start_or_attach(config)

nnoremap("<leader>sc", "opublic class  {<CR>}<ESC>k03f i")

--vim.api.nvim_create_autocmd("BufWritePre", {
--        buffer = buffer,
--        callback = function()
--            local params = {
--                command = "_typescript.organizeImports",
--                arguments = {vim.api.nvim_buf_get_name(0)},
--                title = ""
--            }
--            vim.lsp.buf.execute_command(params)
--            vim.lsp.buf.format { async = false }
--        end
--})

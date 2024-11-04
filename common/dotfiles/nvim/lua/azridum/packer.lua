
-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
    -- Packer can manage itself
    use 'wbthomason/packer.nvim'
    --use {
    --    'TimUntersberger/neogit', 
    --    requires = {
    --        'nvim-lua/plenary.nvim', 'sindrets/diffview.nvim', 'kyazdani42/nvim-web-devicons'
    --    }
    --}
    use 'mfussenegger/nvim-jdtls'
    use {,
        'nvim-telescope/telescope.nvim',
        tag = '0.1.4',
        requires = { 
            {'nvim-lua/plenary.nvim'}
        }
    }
    use 'nvim-tree/nvim-web-devicons'
    use 'nvim-telescope/telescope-symbols.nvim'
    use 'mfussenegger/nvim-dap'
    use({'nvim-treesitter/nvim-treesitter', run = ":TSUpdate"})
    use 'Mofiqul/dracula.nvim'
    use 'neovim/nvim-lspconfig'
    use 'hrsh7th/cmp-nvim-lsp'
    use 'hrsh7th/cmp-buffer'
    use 'hrsh7th/cmp-path'
    use 'hrsh7th/cmp-cmdline'
    use({"hrsh7th/nvim-cmp", requires = {"volvofixthis/cmp-dbee", branch = "packer"}})
    --use 'hrsh7th/cmp-vsnip'
    --use 'hrsh7th/vim-vsnip'
    --use 'github/copilot.vim'
    use {
	    "L3MON4D3/LuaSnip",
	    -- follow latest release.
	    tag = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
	    -- install jsregexp (optional!:).
	    run = "make install_jsregexp"
    }
    use 'rafamadriz/friendly-snippets'
    use 'saadparwaiz1/cmp_luasnip'
    use {
        "kdheepak/lazygit.nvim",
        requires = {
            "nvim-lua/plenary.nvim",
        },
    }
    use 'leoluz/nvim-dap-go'
    use 'David-Kunz/gen.nvim'
    use { "catppuccin/nvim", as = "catppuccin" }
    use {
        'pwntester/octo.nvim',
        requires = {
            'nvim-lua/plenary.nvim',
            'nvim-telescope/telescope.nvim',
            'nvim-tree/nvim-web-devicons',
        },
        config = function ()
            require"octo".setup({
                suppress_missing_scope = {
                    projects_v2 = true,
                }
            })
        end
    }
    use {
        "kndndrj/nvim-dbee",
        requires = {
            "MunifTanjim/nui.nvim",
        },
        run = function()
            -- Install tries to automatically detect the install method.
            -- if it fails, try calling it with one of these parameters:
            --    "curl", "wget", "bitsadmin", "go"
            require("dbee").install()
        end,
    }
end)

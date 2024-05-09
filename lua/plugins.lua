-- `lua require('plugins')` from your init.vim
vim.g.mapleader = ' '

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

-- Mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
return require('packer').startup(function(use)
    -- Packer can manage itself
    use 'wbthomason/packer.nvim'

    use 'tpope/vim-fugitive'
    use 'MTDL9/vim-log-highlighting'
    use({
        "epwalsh/obsidian.nvim",
        config = function()
            require("obsidian").setup({
                dir = "~/for_all",
            })
        end,
    })

    use 'preservim/nerdtree'
    vim.keymap.set('n', '<space>J', ":NERDTreeToggle<CR>")
    vim.keymap.set('n', '<space>j', ":NERDTreeFocus<CR>")
    vim.keymap.set('i', '<C-J>', '<C-x><C-o>')

    use 'neovim/nvim-lspconfig' -- Configurations for Nvim LSP
    require 'lspconfig'.clangd.setup {}
    require 'lspconfig'.rust_analyzer.setup {}
    require 'lspconfig'.lua_ls.setup {
        cmd = {
            "/home/denyskurishchenko/tools/lua-language-server/bin/lua-language-server",
        },
        settings = {
            Lua = {
                runtime = {
                    -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
                    version = 'LuaJIT',
                },
                diagnostics = {
                    -- Get the language server to recognize the `vim` global
                    globals = { 'vim' },
                },
                workspace = {
                    -- Make the server aware of Neovim runtime files
                    library = vim.api.nvim_get_runtime_file("", true),
                    checkThirdParty = false
                },
                -- Do not send telemetry data containing a randomized but unique identifier
                telemetry = {
                    enable = false,
                },
            },
        },
    }
    require 'lspconfig'.pyright.setup {}

    vim.keymap.set('n', '<space>e', vim.diagnostic.open_float)
    vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
    vim.keymap.set('n', ']d', vim.diagnostic.goto_next)

    -- Use LspAttach autocommand to only map the following keys
    vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('UserLspConfig', {}),
        callback = function(ev)
            vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'
            local opts = { buffer = ev.buf }
            vim.keymap.set('n', '<space>D', vim.lsp.buf.declaration, opts)
            vim.keymap.set('n', '<space>d', vim.lsp.buf.definition, opts)
            vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
            vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
            vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
            vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
            vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
            vim.keymap.set('n', '<space>wl', function()
                print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
            end, opts)
            vim.keymap.set('n', '<space>td', vim.lsp.buf.type_definition, opts)
            vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
            vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)
            vim.keymap.set('n', '<space>rr', vim.lsp.buf.references, opts)
        end,
    })
    use { "folke/neodev.nvim", opts = {} }
    use { 'dasupradyumna/midnight.nvim' }
    use { "svermeulen/text-to-colorscheme.nvim" }
    require("text-to-colorscheme").setup(
        {
            ai = {
                gpt_model = "gpt-3.5-turbo",
                openai_api_key = assert(io.open("/home/denyskurishchenko/.config/nvim/openai_key.txt", "r")):read("l"),
                green_darkening_amount = 0.85,
                auto_darken_greens = true,
                minimum_foreground_contrast = 0.4,
                enable_minimum_foreground_contrast = true,
                temperature = 0,
            },
            hex_palettes = {
                {
                    name = "Arrakis",
                    background_mode = "dark",
                    background = "#1e1b10",
                    foreground = "#d9d2b3",
                    accents = {
                        "#e76f51",
                        "#457b9d",
                        "#e9c46a",
                        "#24857a",
                        "#3c6f84",
                        "#f4a261",
                        "#f4a261",
                    }
                },
                {
                    name = "contrast",
                    background_mode = "dark",
                    background = "#000000",
                    foreground = "#ffffff",
                    accents = {
                        "#ff0000",
                        "#00d900",
                        "#0000ff",
                        "#ffff00",
                        "#ff00ff",
                        "#00ffff",
                        "#ff8000",
                    }
                }
            },
            overrides = {},
            default_palette = "gruvbox",
        })

    use 'nvim-treesitter/nvim-treesitter'
    require 'nvim-treesitter.configs'.setup {
        ensure_installed = { c, cpp, cmake, json, rust, bash },
        highlight = {
            enable = true
        },
        indent = {
            enable = true
        }
    }

    use {
        'nvim-telescope/telescope.nvim', tag = '0.1.0',
        requires = { { 'nvim-lua/plenary.nvim' } }
    }
    local builtin = require('telescope.builtin');
    vim.keymap.set('n', '<leader>sf', builtin.find_files, {})
    vim.keymap.set('n', '<leader>sg', builtin.git_files, {})
    vim.keymap.set('n', '<leader>ss', function()
        builtin.grep_string({ search = vim.fn.input("Grep > ") })
    end);

    use 'lewis6991/gitsigns.nvim'
    require 'gitsigns'.setup {
        on_attach = function(bufnr)
            local function map(mode, lhs, rhs, opts)
                opts = vim.tbl_extend('force', { noremap = true, silent = true }, opts or {})
                vim.api.nvim_buf_set_keymap(bufnr, mode, lhs, rhs, opts)
            end

            -- Navigation
            map('n', '<leader>an', "&diff ? '<leader>an' : ':Gitsigns next_hunk<CR>'", { expr = true })
            map('n', '<leader>ap', "&diff ? '<leader>ap' : ':Gitsigns prev_hunk<CR>'", { expr = true })

            -- Actions
            map('n', '<leader>hs', ':Gitsigns stage_hunk<CR>')
            map('v', '<leader>hs', ':Gitsigns stage_hunk<CR>')
            map('n', '<leader>hr', ':Gitsigns reset_hunk<CR>')
            map('v', '<leader>hr', ':Gitsigns reset_hunk<CR>')
            map('n', '<leader>hS', '<cmd>Gitsigns stage_buffer<CR>')
            map('n', '<leader>hu', '<cmd>Gitsigns undo_stage_hunk<CR>')
            map('n', '<leader>hR', '<cmd>Gitsigns reset_buffer<CR>')
            map('n', '<space>hp', '<cmd>Gitsigns preview_hunk<CR>')
            map('n', '<leader>hb', '<cmd>lua require"gitsigns".blame_line{full=true}<CR>')
            map('n', '<leader>tb', '<cmd>Gitsigns toggle_current_line_blame<CR>')
            map('n', '<leader>hd', '<cmd>Gitsigns diffthis<CR>')
            map('n', '<leader>hD', '<cmd>lua require"gitsigns".diffthis("~")<CR>')

            -- Text object
            map('o', 'ih', ':<C-U>Gitsigns select_hunk<CR>')
            map('x', 'ih', ':<C-U>Gitsigns select_hunk<CR>')
        end
    }
    use 'junegunn/fzf'
    use 'junegunn/fzf.vim'
    use 'ThePrimeagen/vim-be-good'

    use 'ThePrimeagen/harpoon'
    vim.keymap.set('n', '<leader>ha', function() require("harpoon.mark").add_file() end)
    vim.keymap.set('n', '<leader>hm', function() require("harpoon.ui").toggle_quick_menu() end)
    vim.keymap.set('n', '<leader>hn', function() require("harpoon.ui").nav_next() end)
    vim.keymap.set('n', '<leader>hp', function() require("harpoon.ui").nav_prev() end)
end)

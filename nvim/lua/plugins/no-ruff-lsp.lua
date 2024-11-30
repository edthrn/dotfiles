-- Disable automatic ruff
-- From https://github.com/LazyVim/LazyVim/discussions/3907#discussioncomment-9955547
return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      ruff_lsp = {
        mason = false,
        enabled = false,
      },
    },
  },
}

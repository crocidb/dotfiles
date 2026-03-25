-- load defaults i.e lua_lsp
require("nvchad.configs.lspconfig").defaults()

vim.lsp.enable("ts_ls")
vim.lsp.enable("clangd")
vim.lsp.enable("html")
vim.lsp.enable("cssls")
-- vim.lsp.enable("pyright")
vim.lsp.enable("ty")
vim.lsp.enable("gdscript")
vim.lsp.enable("racket_langserver")
vim.lsp.enable("glsl_analyzer")
vim.lsp.enable("harper_ls")

-- Diagnostics
vim.diagnostic.config({
	virtual_lines = true,
	virtual_text = false,
	underline = true,
	signs = true,
	severity_sort = true,
	update_in_insert = false,
})

-- Using trouble for quickfix list when finding references
local function on_list(options)
	vim.fn.setqflist({}, " ", options)
	require("trouble").open({ mode = "quickfix" })
end

function LspReferences()
	vim.lsp.buf.references(nil, { on_list = on_list })
end

vim.keymap.set("n", "grr", "<cmd> lua LspReferences() <CR>", { noremap = true, silent = true })

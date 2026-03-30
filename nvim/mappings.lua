require("nvchad.mappings")

-- Maps
vim.api.nvim_del_keymap("n", "<leader>fz")
local map = vim.keymap.set
vim.g.maplocalleader = ","
vim.opt.clipboard = "unnamedplus"

-- Misc
map("v", ".", '"_d".P', { desc = "Replace selection with last insertion" })
map("v", "<leader>fz", "<cmd>lua LiveGrepVisual()<CR> ", { noremap = true, silent = true })
map("n", "<leader>fw", "<cmd>lua LiveGrepCurrentWord()<CR>", { noremap = true, silent = true })

map("n", "<leader>tx", ":tabclose<CR>", { noremap = true, silent = true })
map("n", "<leader>tn", ":tabnext<CR>", { noremap = true, silent = true })
map("n", "<leader>tp", ":tabprevious<CR>", { noremap = true, silent = true })
map("n", "<leader>tc", ":tabnew<CR>", { noremap = true, silent = true })

-- Telescope
map("n", "<leader>fz", "<cmd> Telescope live_grep<CR>", { noremap = true, silent = true })
map("n", "<leader>tt", "<cmd> Telescope<CR>", { desc = "Telescope Document Symbols" })
map("n", "<leader>te", "<cmd> NoiceTelescope<CR>", { desc = "Show all notifications, warnings and errors" })
map("n", "<leader>ss", "<cmd> Telescope lsp_document_symbols <CR>", { desc = "Telescope Document Symbols" })
map("n", "<leader>dd", "<cmd> Telescope diagnostics <CR>", { desc = "Telescope Document Symbols" })
map(
	"n",
	"<leader>m",
	"<cmd> Telescope lsp_document_symbols symbols=function,method <CR>",
	{ desc = "Telescope Document Symbols" }
)

-- Motions
map("v", "//", [[y/\V<C-R>=escape(@", '/\')<CR><CR>]], { noremap = true, silent = true })
map("n", "//", [[:let @/='\V' . escape(expand('<cword>'), '/\')<CR>n]], { noremap = true, silent = true })
map("n", "{", "<C-O>")
map("n", "}", "<C-I>")
map("n", "(", "[m")
map("n", ")", "]m")
map("v", "<A-S-k>", ":m '<-2<CR>gv=gv", { noremap = true, silent = true })
map("v", "<A-S-j>", ":m '>+1<CR>gv=gv", { noremap = true, silent = true })
map("i", "<C-BS>", "<C-w>", { noremap = true, silent = true })
map("n", "bv", "f{%V%", { noremap = true, desc = "select whole block ahead with this line" })

-- LSP/Format
map("n", "<leader>fm", "<cmd> lua require('conform').format() <CR>", { desc = "Format file with Formatter" })
map(
	"n",
	"<leader>vl",
	"<cmd> lua VirtualLineToggle()<CR>",
	{ noremap = true, silent = true, desc = "Toggle virtual lines for diagnostics" }
)
map(
	"n",
	"<leader>dn",
	"<cmd> lua vim.diagnostic.goto_next()<CR>",
	{ noremap = true, silent = true, desc = "Go to next diagnostic" }
)

-- Git Stuff
map("n", "<leader>df", ":DiffviewOpen<CR>", { noremap = true, silent = true })
map("n", "<leader>dF", "<cmd> lua OpenDiffviewWithCommits()<CR>", { noremap = true, silent = true })

-- CodeLens
-- map("n", "<leader>rr", "<cmd> LaunchTask<CR>", { desc = "Launch Task" })
-- map("n", "<leader>rl", "<Cmd>lua vim.lsp.codelens.run()<CR>", { desc = "Run Code Lens" })
-- map("n", "<leader>rf", "<Cmd>lua vim.lsp.codelens.refresh()<CR>", { desc = "Refresh Code Lens" })

-- Copilot
map({ "n", "v" }, "<M-C>", "<cmd>CodeCompanionChat Toggle<cr>", { noremap = true, silent = true })
map({ "n", "v" }, "<M-p>", "<cmd> CopilotChatToggle <CR>")
map({ "n", "v" }, "<M-P>", "<cmd> lua CopilotChatQuickPrompt()<CR>")

-- Tmux/Vim Navagations
map("n", "<c-h>", "<cmd>TmuxNavigateLeft<cr>")
map("n", "<c-j>", "<cmd>TmuxNavigateDown<cr>")
map("n", "<c-k>", "<cmd>TmuxNavigateUp<cr>")
map("n", "<c-l>", "<cmd>TmuxNavigateRight<cr>")
map("n", "<c-\\>", "<cmd>TmuxNavigatePrevious<cr>")


-- Some auxiliary functions
function CopilotChatActions()
	local actions = require("CopilotChat.actions")
	require("CopilotChat.integrations.telescope").pick(actions.prompt_actions(), { previewer = false })
end

function CopilotChatQuickPrompt()
	local prompt = vim.fn.input("Ask Copilot: ")
	if prompt ~= "" then
		local chat = require("CopilotChat")
		chat.ask(prompt, {
			selection = function(source)
				local select = require("CopilotChat.select")
				return select.visual(source) or select.buffer(source)
			end,
			context = { "buffers", "files" },
			callback = function(response)
				print("Response:", response)
			end,
		})
	end
end

function VirtualLineToggle()
	local current_config = vim.diagnostic.config()
	local new_virtual_lines_state
	if current_config.virtual_lines == nil or current_config.virtual_lines == false then
		new_virtual_lines_state = true
	else
		new_virtual_lines_state = false
	end
	vim.diagnostic.config({ virtual_lines = new_virtual_lines_state, virtual_text = not new_virtual_lines_state })
	vim.notify("Virtual lines " .. (new_virtual_lines_state and "enabled" or "disabled"), vim.log.levels.INFO)
end

function LiveGrepVisual()
	local mode = vim.fn.mode()
	if mode ~= "v" and mode ~= "V" then
		return
	end
	local _, ls, cs = unpack(vim.fn.getpos("v"))
	local _, le, ce = unpack(vim.fn.getpos("."))
	if ls > le or (ls == le and cs > ce) then
		ls, le = le, ls
		cs, ce = ce, cs
	end
	local lines = vim.fn.getline(ls, le)
	if #lines == 0 then
		return
	end
	lines[#lines] = string.sub(lines[#lines], 1, ce)
	lines[1] = string.sub(lines[1], cs)
	local text = table.concat(lines, "\n")
	text = text:gsub("\n", " ")
	require("telescope.builtin").live_grep({ default_text = text })
	vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<BS>", true, false, true), "n", false)
end

function LiveGrepCurrentWord()
  local word = vim.fn.expand("<cword>")
  require('telescope.builtin').live_grep({ default_text = word })
end

function OpenDiffviewWithCommits()
  vim.ui.input({ prompt = "How many commits do you want to view diff? " }, function(input)
    if not input or input == "" then
      return
    end
    local n = tonumber(input)
    if not n or n < 1 then
      vim.notify("Invalid number: " .. input, vim.log.levels.ERROR)
      return
    end
    vim.cmd("DiffviewOpen HEAD~" .. n)
  end)
end

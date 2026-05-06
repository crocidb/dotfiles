local opts = {
	instructions_file = "avante.md",

	provider = "opencode", -- Set OpenCode as the default provider
	auto_suggestions_provider = "opencode",

	mappings = {
		ask = "<M-p>", -- Alt+P to open/close chat
		edit = "<M-e>",
		refresh = "<M-r>",
		focus = "<M-f>",
		stop = "<M-s>",
		toggle = {
			diff = "<M-d>",
			hint = "<M-h>",
			suggestion = "<M-c>",
			repomap = "<M-R>",
		},
		select_model = "<M-m>",
		select_history = "<M-H>",
	},

	acp_providers = {
		["opencode"] = {
			command = "opencode",
			args = { "acp" },
			env = {
				OPENCODE_API_KEY = os.getenv("OPENCODE_API_KEY"),
			},
		},
	},
	input = {
		provider = "dressing", -- "native" | "dressing" | "snacks"
		provider_opts = {
			-- Snacks input configuration
			title = "Avante Input",
			icon = " ",
			placeholder = "Enter your API key...",
		},
	},
	selector = {
		provider = "telescope",
		provider_opts = {},
	},
}

return opts

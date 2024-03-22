return {
	"ellisonleao/gruvbox.nvim",
	priority = 1000,
	config = function()
		require("gruvbox").setup({
			italic = {
				strings = false,
				emphasis = true,
				comments = true,
				operators = false,
				folds = true,
			},
		})

		vim.o.background = "dark"
		vim.cmd([[colorscheme gruvbox]])
	end,
}

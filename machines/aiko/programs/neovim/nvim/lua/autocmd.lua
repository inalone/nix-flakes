vim.api.nvim_create_autocmd("FileType", {
	pattern = { "markdown" },
	callback = function()
		vim.opt.spelllang = "en_gb"
		vim.opt.spell = true
	end,
})

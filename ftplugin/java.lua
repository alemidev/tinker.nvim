local nvim_jdtls = require("jdtls")
nvim_jdtls.start_or_attach({
    cmd = { 'jdtls' },
    root_dir = vim.fs.dirname(vim.fs.find({'.gradlew', '.git', 'mvnw'}, {upward = true})[1]),
})
require('keybinds'):set_lsp_keys({buffer = 0})

return function()
  require('fzf-lua').setup {
    winopts = {
      preview = {
        vertical = 'up:60%',
        layout = 'vertical',
        scrollbar = false
      }
    },
    fzf_opts = {
      ['--layout'] = 'default'
    },
    grep = {
      rg_opts =
      '--hidden --column --line-number --no-heading --color=always --smart-case --max-columns=512 --glob=!.git/',
    }
  }
end

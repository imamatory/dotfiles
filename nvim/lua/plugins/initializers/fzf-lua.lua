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
    }
  }
end

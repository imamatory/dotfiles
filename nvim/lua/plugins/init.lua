-- local fuzzyfinder = {
--   { 'junegunn/fzf.vim' },
--   {
--     'nvim-telescope/telescope.nvim',
--     branch = '0.1.x',
--     requires = { { 'nvim-lua/plenary.nvim' } },
--     config = require('plugins.initializers.telescope-nvim')
--   },
-- }

local fuzzyfinder = {
  'ibhagwan/fzf-lua',
  requires = { 'nvim-tree/nvim-web-devicons' },
  config = require('plugins.initializers.fzf-lua'),
}

local treesitter = {
  'nvim-treesitter/nvim-treesitter',
  config = require('plugins.initializers.nvim-treesitter'),
  run = function()
    local ts_update = require('nvim-treesitter.install').update({ with_sync = true })
    ts_update()
  end,
}

return require('packer').startup({
  function(use)
    use 'wbthomason/packer.nvim'
    require('plugins.lsp').run(use)
    use(treesitter)
    use { 'windwp/nvim-spectre', requires = { 'nvim-lua/plenary.nvim' }, }
    use(fuzzyfinder)
    use 'tpope/vim-sensible'
    use 'tpope/vim-surround'
    use 'tpope/vim-repeat'
    use 'nathanaelkane/vim-indent-guides'
    use 'scrooloose/nerdtree'
    use 'vim-airline/vim-airline'
    use 'vim-airline/vim-airline-themes'
    use { 'catppuccin/nvim', as = 'catppuccin' }
    use 'xolox/vim-misc'
    use 'terryma/vim-multiple-cursors'
    use 'tpope/vim-commentary'
    use 'tpope/vim-abolish'
    use 'tpope/vim-fugitive'
    use 'michaeljsmith/vim-indent-object'
    use 'Chiel92/vim-autoformat'
    use 'imamatory/leader-clipboard'
    use 'digitaltoad/vim-pug'
    use 'elzr/vim-json'
    use 'AndrewRadev/splitjoin.vim'
    use 'ap/vim-css-color'
    use 'hhsnopek/vim-sugarss'
    use 'slashmili/alchemist.vim'
    use 'ekalinin/Dockerfile.vim'
    use 'editorconfig/editorconfig-vim'
    use 'dyng/ctrlsf.vim'
    use 'junegunn/vim-easy-align'
    use 'vtm9/vim-dispatch'
    use 'janko-m/vim-test'
    use 'airblade/vim-rooter'
    use { 'numToStr/Navigator.nvim', config = require('plugins.initializers.navigator-nvim') }
    use 'jszakmeister/vim-togglecursor'
    use 'vtm9/vim-pry'
    use 'kana/vim-textobj-user'
    use 'whatyouhide/vim-textobj-xmlattr'
    use 'nelstrom/vim-textobj-rubyblock'
    use 'sheerun/vim-polyglot'
    use({
      'iamcco/markdown-preview.nvim',
      run = 'cd app && yarn install',
      setup = function() vim.g.mkdp_filetypes = { 'markdown' } end,
      ft = { 'markdown' }
    })
    use { 'github/copilot.vim', config = require('plugins.initializers.copilot-vim') }
    use({
      'jackMort/ChatGPT.nvim',
      config = function()
        require('chatgpt').setup()
      end,
      requires = {
        'MunifTanjim/nui.nvim',
        'nvim-lua/plenary.nvim',
        'nvim-telescope/telescope.nvim'
      }
    })
  end,
  config = {
    display = {
      open_fn = require('packer.util').float,
    }
  }
})

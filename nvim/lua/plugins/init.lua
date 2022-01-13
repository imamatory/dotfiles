return require('packer').startup({
    function(use)
      use 'wbthomason/packer.nvim'
      use 'tpope/vim-sensible'
      use 'tpope/vim-surround'
      use 'tpope/vim-repeat'
      use 'nathanaelkane/vim-indent-guides'
      use 'scrooloose/nerdtree'
      use 'nanotech/jellybeans.vim'
      use 'marko-cerovac/material.nvim'
      use 'trevordmiller/nova-vim'
      use 'vim-airline/vim-airline'
      use 'vim-airline/vim-airline-themes'
      use 'xolox/vim-misc'
      use 'terryma/vim-multiple-cursors'
      use 'tpope/vim-commentary'
      use 'tpope/vim-abolish'
      use 'tpope/vim-fugitive'
      use 'michaeljsmith/vim-indent-object'
      use 'Chiel92/vim-autoformat'
      use 'maxmellon/vim-jsx-pretty'
      use 'imamatory/leader-clipboard'
      use 'digitaltoad/vim-pug'
      use 'elzr/vim-json'
      use 'tpope/vim-bundler'
      use 'tpope/vim-rails'
      use 'vim-ruby/vim-ruby'
      use 'AndrewRadev/splitjoin.vim'
      use 'ap/vim-css-color'
      use 'hhsnopek/vim-sugarss'
      use 'slashmili/alchemist.vim'
      use 'elixir-lang/vim-elixir'
      use 'c-brenn/phoenix.vim'
      use 'onemanstartup/vim-slim'
      use 'ekalinin/Dockerfile.vim'
      use 'editorconfig/editorconfig-vim'
      use { 'ibhagwan/fzf-lua',
        -- optional for icon support
        requires = { 'kyazdani42/nvim-web-devicons' },
        config = function () require('plugins.initializers.fzf-lua').setup() end
      }
      use 'dyng/ctrlsf.vim'
      use 'junegunn/vim-easy-align'
      use 'vtm9/vim-dispatch'
      use 'janko-m/vim-test'
      use 'airblade/vim-rooter'
      use 'christoomey/vim-tmux-navigator'
      use 'jszakmeister/vim-togglecursor'
      use 'vtm9/vim-pry'
      use 'kana/vim-textobj-user'
      use 'whatyouhide/vim-textobj-xmlattr'
      use 'nelstrom/vim-textobj-rubyblock'
      use 'sheerun/vim-polyglot'
    end,
    config = {
      display = {
        open_fn = require('packer.util').float,
      }
    }
  })

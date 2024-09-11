{lib, pkgs, ...}: {
  imports = [ 
  ];

  clipboard = {
    register = "unnamedplus"; # put yanked text into system clipboard
    providers = {
      wl-copy = {
        enable = true;
        package = pkgs.wl-clipboard;
      };
    };

  };

  keymaps = [
    { # escape insert mode with jj
      mode = "i";
      key = "jj";
      action = "<Esc>";
    }
    { # don't escape visual mode after changing indent (gv re-selects previous block)
      mode = "v";
      key = "<";
      action = "<gv";
    }
    {
      mode = "v";
      key = ">";
      action = ">gv";
    }
    { # exit visual mode with space
      mode = "v";
      key = "<Space>";
      action = "<Esc>";
    }
  ];

  opts = {
    signcolumn = "yes:1";
    expandtab = true;
    smarttab = true;
    shiftwidth = 2;
    tabstop = 2;
    softtabstop = 2;
    mouse = "a";
    number = true;
    encoding = "utf-8";
    fileencoding = "utf-8";
    smartcase = true; 
    cursorline = true; # highlight current line
    hlsearch = true; # highlight search results
    ignorecase = true; # ignore case while searching
    incsearch = true; # make search act like in modern browsers
    ruler = true; # always show cursor
    autoindent = true;
    smartindent = true;
    cindent = true;
    # wrap = false; # don't wrap text
    breakindent = true; # indent wrapped text (https://stackoverflow.com/questions/1204149/smart-wrap-in-vim)
    showbreak = ">>"; # highlight wrapped text
    # copyindent = true; 
    showmode = false; # dont show mode
    cmdheight = 0; # more space for command line
    scrolloff = 8; # keep 8 lines above/below cursor

    globals.mapleader = ","; # change the leader key

    # fortran stuff ... haven't tested if this helps
    # fortran_free_source = 1;
    # fortran_do_enddo = 1;

  };

  colorschemes.onedark = {
    enable = true;
    settings.style = "warmer";
  };

  plugins = {

    indent-blankline.enable = true;

    todo-comments.enable = true; # highlight todo comments

    gitsigns.enable = true;

    treesitter = {
      enable = true; # default with all grammar
      settings = {
        indent.enable = true;
      };
    };

    lsp = {
      enable = true;
      servers = {
        nil-ls.enable = true; # nix
        ltex = { # latex
          enable = true;
          settings.language = "en-US";
        };
        pyright.enable = true; # python
        clangd.enable = true; # C/C++
        fortls.enable = true; # fortran
        jsonls.enable = true; # json
        yamlls.enable = true; # yaml
      };
      keymaps = {
        diagnostic = {
          "<space>j" = "goto_next";
          "<space>k" = "goto_prev";
        };
        lspBuf = {
          K = "hover";
          gr = "references";
          gd = "definition";
          gi = "implementation";
          gt = "type_definition";
          "<space>ca" = "code_action";
          "<space>rn" = "rename";
        };
      };
    };
    # cmp autocomplete
    cmp.enable = true;
    cmp-cmdline.enable = true;
    cmp-treesitter.enable = true;
    cmp-path.enable = true;
    cmp-buffer.enable = true;
    cmp-nvim-lsp.enable = true;
    cmp-vim-lsp.enable = true;
    cmp-vsnip.enable = true;
    cmp-zsh.enable = true;
    # lsp-signature.enable = true; # show function signature (plugin does not exist?)

  };

}

{lib, pkgs, ...}: {
  imports = [ 
  ];
  # test
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
      action = "<esc>";
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
      key = "<space>";
      action = "<esc>";
    }
    { # switch to next buffer
      mode = "n";
      key = "<c-w>n";
      action = ":bn<cr>";
    }
    { # switch to previous buffer
      mode = "n";
      key = "<c-w>p";
      action = ":bp<cr>";
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

    # fortran stuff ... haven't tested if this helps
    # fortran_free_source = 1;
    # fortran_do_enddo = 1;

  };

  globals.mapleader = " "; # change the leader key to space

  colorschemes.onedark = {
    enable = true;
    settings.style = "warmer";
  };

  plugins = {

    # vertical lines for indents
    indent-blankline.enable = true;

    todo-comments = {
      # provides these highlights:
      # FIX: 
      # TODO: 
      # HACK: 
      # WARN: 
      # WARNING: 
      # PERF: 
      # XXX: 
      # INFO: 
      # NOTE: 
      # TEST: 
      enable = true;
    };

    # show git changes on the left side
    gitsigns.enable = true; 

    # tabs on top
    bufferline.enable = true;

    # fuzzy search
    telescope = {
      enable = true; 
      settings = {
        defaults = {
          mappings = {
            # exit telescope with esc
            i = {
              "<esc>" = {
                __raw = ''
                  function(...)
                    return require("telescope.actions").close(...)
                  end'';
              };
            };
          };
        };
      };
      keymaps = {
        # More options to be found here: https://github.com/nvim-telescope/telescope.nvim/blob/master/README.md
        "<leader>f" = {
          action = "find_files";
          options.desc = "Find project files";
        };
        "<leader>g" = {
          action = "live_grep";
          options.desc = "Grep (root dir)";
        };
        "<leader>b" = {
          action = "buffers";
          options.desc = "+buffer";
        };
        "<leader>cb" = {
          action = "current_buffer_fuzzy_find";
          options.desc = "Buffer";
        };
      };
    };

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
          "<leader>j" = "goto_next";
          "<leader>k" = "goto_prev";
        };
        lspBuf = {
          K = "hover";
          gr = "references";
          gd = "definition";
          gi = "implementation";
          gt = "type_definition";
          "<leader>ca" = "code_action";
          "<leader>rn" = "rename";
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

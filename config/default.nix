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
    # { # switch to next buffer
    #   mode = "n";
    #   key = "<leader>bn";
    #   action = ":bn<cr>";
    # }
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

    indent-blankline.enable = true;

    # TODO: Change color of TODO
    todo-comments.enable = true; # highlight todo comments

    gitsigns.enable = true;

    bufferline.enable = true;

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
        # "<leader>:" = {
        #   action = "command_history";
        #   options.desc = "Command History";
        # };
        # "<leader>fr" = {
        #   action = "oldfiles";
        #   options.desc = "Recent";
        # };
        # "<leader>fb" = {
        #   action = "buffers";
        #   options.desc = "Buffers";
        # };
        # "<C-p>" = {
        #   action = "git_files";
        #   options.desc = "Search git files";
        # };
        # "<leader>gc" = {
        #   action = "git_commits";
        #   options.desc = "Commits";
        # };
        # "<leader>gs" = {
        #   action = "git_status";
        #   options.desc = "Status";
        # };
        # "<leader>sa" = {
        #   action = "autocommands";
        #   options.desc = "Auto Commands";
        # };
        # "<leader>sb" = {
        #   action = "current_buffer_fuzzy_find";
        #   options.desc = "Buffer";
        # };
        # "<leader>sc" = {
        #   action = "command_history";
        #   options.desc = "Command History";
        # };
        # "<leader>sC" = {
        #   action = "commands";
        #   options.desc = "Commands";
        # };
        # "<leader>sD" = {
        #   action = "diagnostics";
        #   options.desc = "Workspace diagnostics";
        # };
        # "<leader>sh" = {
        #   action = "help_tags";
        #   options.desc = "Help pages";
        # };
        # "<leader>sH" = {
        #   action = "highlights";
        #   options.desc = "Search Highlight Groups";
        # };
        # "<leader>sk" = {
        #   action = "keymaps";
        #   options.desc = "Keymaps";
        # };
        # "<leader>sM" = {
        #   action = "man_pages";
        #   options.desc = "Man pages";
        # };
        # "<leader>sm" = {
        #   action = "marks";
        #   options.desc = "Jump to Mark";
        # };
        # "<leader>so" = {
        #   action = "vim_options";
        #   options.desc = "Options";
        # };
        # "<leader>sR" = {
        #   action = "resume";
        #   options.desc = "Resume";
        # };
        # "<leader>uC" = {
        #   action = "colorscheme";
        #   options.desc = "Colorscheme preview";
        # };
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

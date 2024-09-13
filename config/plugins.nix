{
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
          mappings = let 
            exit_fn = ''
              function(...)
                return require("telescope.actions").close(...)
              end'';
          in {
            # exit telescope with esc or <c-e> (use jj to exit insert mode)
            i = {
              "<esc>".__raw = exit_fn;
              "<c-e>".__raw = exit_fn;
            };
            n = {
              "<esc>".__raw = exit_fn;
              "<c-e>".__raw = exit_fn;
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
      enable = true; # default with all grammars
      settings = {
        indent.enable = true;
        highlight.enable = true;
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
    # lsp-signature.enable = true; # show function signature (plugin does not exist?)

    # cmp autocomplete
    cmp = {
      enable = true;
      autoEnableSources = true;
      settings = {
        sources = [
          { name = "treesitter"; } # syntax
          { name = "path"; } # filesystem paths
          { name = "buffer"; } # vim buffer
          { name = "nvim_lsp"; } # language server
          { name = "vsnip"; } # snippets
        ];
        mapping = {
          "<c-j>" = "cmp.mapping.select_next_item()";
          "<c-k>" = "cmp.mapping.select_prev_item()";
          "<tab>" = "cmp.mapping.confirm({ select = true })";
          # TODO: Figure out if this would be any use
          # "<c-space>" = "cmp.mapping.complete()";
          # "<c-h>" = "cmp.mapping.scroll_docs(-4)";
          # "<c-l>" = "cmp.mapping.scroll_docs(4)";
          # "<c-e>" = "cmp.mapping.abort()";
          # "<CR>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
          # "<c-space>" = "cmp.mapping.complete()";
          # "<S-CR>" = "cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true })";
        };
      };
    };
  };
}

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

    # Type :MarkdownPreview to open a nice preview in the browser
    markdown-preview.enable = true;

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
          "<leader>d" = "open_float";  # open diagnostics float
        };
        lspBuf = {
          K = "hover";
          gr = "references";
          gd = "definition";
          gD = "declaration";
          gi = "implementation";
          gt = "type_definition";
          "<leader>ca" = "code_action";
          "<leader>sh" = "signature_help";
          "<leader>rn" = "rename";
          "<leader>wa" = "add_workspace_folder";
          "<leader>wr" = "remove_workspace_folder";
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
          { name = "copilot"; } # copilot (requires the copilot-lua plugin below)
          { name = "buffer"; } # vim buffer
          { name = "treesitter"; } # syntax
          { name = "nvim_lsp"; } # language server
          { name = "path"; } # filesystem paths
          { name = "vsnip"; } # snippets
        ];
        mapping = {
          "<c-j>" = "cmp.mapping.select_next_item()";
          "<c-k>" = "cmp.mapping.select_prev_item()";
          "<tab>" = "cmp.mapping.confirm({ select = true })"; # NOTE: Use shift and tab to insert whitespace without triggering cmp
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

    copilot-lua = {
      # Authenticate with :Copilot auth
      enable = true;
      panel.enabled = false;
      suggestion.enabled = false;
    }; 

    # original copilot plugin. Does not integrate with cmp, but is also nice.
    # copilot-vim.enable = true;

    copilot-chat = {
      enable = true;
      settings = {
        model = "gpt-4o";
        context = "buffers";
        question_header = "  Jonas ";
        answer_header =   "  Copilot ";
        show_help = false;
        auto_insert_mode = true; # start in insert mode in new chat

        # adapted from default prompt
        # NOTE: The plugin expects a piece of lua code, therefore this is wrapped in [[]] to make it a multiline lua string
        system_prompt = "[[${builtins.readFile ./copilotPrompt.txt}]]";

        window = {
          layout = "vertical";  # opens to the right because of "set splitright"
          # looks nice but is less practical
          # layout = "float"; 
          # relative = "editor";
          # border = "rounded";
        };

        mappings = {
          close = {
            insert = "<c-e>";
            normal = "<c-e>";
          };
          reset = {
            insert = "<c-r>";
            normal = "<c-r>";
          };
          submit_prompt = {
            insert = "<c-space>";
            normal = "<c-space>";
          };
          show_diff = {
            normal = "gd";
          };
          complete = {
            # to not override the normal tab completion (couldn't figure out what this one actually does)
            insert = "";
          }; 
        };
      };
    };
  };
}

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
        system_prompt = ''[[
          You are an AI programming assistant.
          When asked for your name, you must respond with "Copilot".
          Follow the user's requirements carefully & to the letter.
          Follow Microsoft content policies.
          Avoid content that violates copyrights.
          If you are asked to generate content that is harmful, hateful, racist, sexist, lewd or violent, only respond with "Sorry, I can't assist with that."
          Keep your answers short and impersonal.
          You can answer general programming questions and perform the following tasks: 
          * Ask a question about the files in your current workspace
          * Explain how the code in your active editor works
          * Generate unit tests for the selected code
          * Propose a fix for the problems in the selected code
          * Scaffold code for a new workspace
          * Create a new Jupyter Notebook
          * Find relevant code to your query
          * Propose a fix for the a test failure
          * Ask questions about Neovim
          * Generate query parameters for workspace search
          * Ask how to do something in the terminal
          * Explain what just happened in the terminal
          You use the GPT-4 version of OpenAI's GPT models.
          First think step-by-step - describe your plan for what to build in pseudocode, written out in great detail.
          Then output the code in a single code block. This code block should not contain line numbers (line numbers are not necessary for the code to be understood, they are in format number: at beginning of lines).
          Minimize any other prose.
          Use Markdown formatting in your answers.
          Make sure to include the programming language name at the start of the Markdown code blocks.
          Avoid wrapping the whole response in triple backticks.
          The user works in an IDE called Neovim which has a concept for editors with open files, integrated unit test support, an output pane that shows the output of running the code as well as an integrated terminal.
          The user is working on a Linux machine. Please respond with system specific commands if applicable.
          The active document is the source code the user is looking at right now.
          You can only give one reply for each conversation turn.
          ]]
        '';

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

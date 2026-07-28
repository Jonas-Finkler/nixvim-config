{pkgs, lib, config, ...}:
let
  full = !config.profile.light; # heavy servers/plugins only in the full profile
in {
  # Regex syntax highlighting for justfiles. The treesitter `just` grammar is
  # stale (chokes on x"..." shell-expanded strings and expression-valued
  # settings, cascading into the rest of the file), so we use vim-just and
  # disable treesitter highlighting for `just` below.
  extraPlugins = [ pkgs.vimPlugins.vim-just ];

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

    # :Bwipeout — like :bw, but keeps the window layout
    bufdelete.enable = true;

    # tabs on top
    bufferline = {
      enable = true;
      settings.options.offsets = [
        {
          filetype = "neo-tree";
          text = "File Explorer";
          highlight = "Directory";
          separator = true;
        }
      ];
    };

    # file tree — closed by default, toggled with <leader>t
    neo-tree = {
      enable = true;
      settings = {
        close_if_last_window = true; # never leave a lone tree window behind
        window = {
          width = 30;
          # Unbind neo-tree's <space> = toggle_node. It is declared nowait=false
          # so leader combos keep working, which means every press waits out
          # timeoutlen (1s). <cr> toggles directories anyway, with no delay.
          mappings = {
            "<space>" = "none";
            # hjkl navigation: l expands/opens, h collapses (or jumps to the
            # parent and collapses it). l was focus_preview; P still previews.
            "l" = "open";
            "h" = "close_node";
          };
        };
        # Must be explicit: neo-tree passes an unset value straight to
        # log.use_file(), and only a literal `false` disables the log file.
        log_to_file = false;
        filesystem = {
          follow_current_file.enabled = true;
          filtered_items.hide_dotfiles = false;
        };
      };
    };

    # Type :MarkdownPreview to open a nice preview in the browser (pulls node)
    markdown-preview.enable = full;

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
        # LSP references with preview + fuzzy filtering (replaces vim.lsp.buf.references,
        # which dumps into the quickfix list)
        "gr" = {
          action = "lsp_references";
          options.desc = "Find usages (LSP references)";
        };
      };
    };

    # needed by telescope and bufferline
    web-devicons = {
      enable = true;
    };

    treesitter = {
      enable = true; # default with all grammars
      # settings = {
        indent.enable = true;
        highlight.enable = true;
        highlight.disable = [ "just" ]; # use vim-just instead (grammar is stale)
      # };
    };

    lsp = {
      enable = true;
      servers = {
        nil_ls = { # nix — tiny, kept in the light profile too
          enable = true;
          # NixVim already namespaces these under the ["nil"] settings key, so
          # do NOT wrap them in another "nil" (that double-nesting silently
          # disabled autoArchive and made nil nag on every Nix file).
          settings.nix.flake.autoArchive = true;
        };
      # Heavy language servers — each drags in a full toolchain (clang/llvm,
      # rustc/cargo, openjdk, node, ...). Full profile only; see default.nix.
      } // lib.optionalAttrs full {
        ltex = { # latex
          enable = true;
          settings.language = "en-US";
        };
        pyright.enable = true; # python
        clangd.enable = true; # C/C++
        fortls.enable = true; # fortran
        jsonls.enable = true; # json
        yamlls.enable = true; # yaml
        jdtls.enable = true; # java (there is also a jdtls plugin with more features
        rust_analyzer = { # rust
          enable = true;
          installRustc = true;
          installCargo = true;
        };
      };
      keymaps = {
        diagnostic = {
          "<leader>j" = "goto_next";
          "<leader>k" = "goto_prev";
          "<leader>e" = "open_float";  # for some reason "<leader>d" does not work here
        };
        lspBuf = {
          K = "hover";
          # gr is bound to telescope's lsp_references instead (see telescope.keymaps).
          # An lspBuf mapping here would be buffer-local on LspAttach and shadow it.
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

    # blink.cmp — completion menu (replaces nvim-cmp).
    # Copilot suggestions show up as a source in the menu via blink-copilot.
    blink-cmp = {
      enable = true;
      settings = {
        keymap = {
          preset = "default";
          "<C-j>" = [ "select_next" "fallback" ];
          "<C-k>" = [ "select_prev" "fallback" ];
          "<Tab>" = [ "accept" "fallback" ];
          # <C-n> opens/toggles the completion menu (manual trigger).
          "<C-n>" = [ "show" "show_documentation" "hide_documentation" ];
          # Release <C-Space> so copilot-chat can use it to submit its prompt.
          "<C-space>" = [ "fallback" ];
        };
        completion.documentation.auto_show = true;
        signature.enabled = true;
        sources = {
          default = [ "lsp" "path" "snippets" "buffer" ] ++ lib.optional full "copilot";
          providers = lib.optionalAttrs full {
            copilot = {
              name = "copilot";
              module = "blink-copilot";
              async = true;
              score_offset = 100;
            };
          };
        };
      };
    };
    blink-copilot.enable = full;

    copilot-lua = {
      # Authenticate with :Copilot auth.
      # Suggestion ghost-text disabled because completions now come through
      # blink-copilot into the blink.cmp menu.
      enable = full;
      settings = {
        panel.enabled = false;
        suggestion.enabled = false;
        telemetry.telemetryLevel = "off";
      };
    };

    # original copilot plugin. Does not integrate with cmp, but is also nice.
    # copilot-vim.enable = true;

    copilot-chat = {
      enable = full;
      settings = {
        # model = "claude-sonnet-4.5";
        resources = ["buffers" "selection" "glob"];
        question_header = "  Jonas ";
        answer_header =   "  Copilot ";
        show_help = false;
        auto_insert_mode = true; # start in insert mode in new chat

        # adapted from default prompt
        # NOTE: The plugin expects a piece of lua code, therefore this is wrapped in [[]] to make it a multiline lua string
        # system_prompt = "[[${builtins.readFile ./copilotPrompt.txt}]]";

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

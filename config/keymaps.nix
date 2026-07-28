{
  globals.mapleader = " "; # change the leader key to space

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
    { # close buffer, keeping the window layout
      # `y`, not `x`: a <c-w>x that lands after timeoutlen runs the builtin, which swaps windows.
      mode = "n";
      key = "<c-w>y";
      action.__raw = ''
        function()
          -- no-op in neo-tree/help/etc. so those buffers can't be wiped
          if vim.fn.buflisted(vim.api.nvim_get_current_buf()) ~= 1 then
            return
          end
          require("bufdelete").bufwipeout(0)
        end
      '';
    }
    { # toggle file tree
      mode = "n";
      key = "<leader>t";
      action = "<cmd>Neotree toggle<cr>";
    }
    { # open file tree on the current file
      mode = "n";
      key = "<leader>T";
      action = "<cmd>Neotree reveal<cr>";
    }
    { # open copilot chat
      mode = "n";
      key = "<leader>cc";
      action.__raw = ''
        function()
          require("CopilotChat").open()
        end
      '';
    }
    { # open copilot chat
      mode = "v";
      key = "<leader>cc";
      action.__raw = ''
        function()
          require("CopilotChat").open()
        end
      '';
    }
  ];
}

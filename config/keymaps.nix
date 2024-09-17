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

{pkgs, ...}: {
  clipboard = {
    register = "unnamedplus"; # put yanked text into system clipboard
    providers = {
      wl-copy = {
        enable = true;
        package = pkgs.wl-clipboard;
      };
    };
  };

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
    splitright = true; # open new panes to the right (also the copilot chat)

    # fortran stuff ... haven't tested if this helps
    # fortran_free_source = 1;
    # fortran_do_enddo = 1;

  };
}

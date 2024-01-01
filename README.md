# kickstart.nvim

## Introduction

A significant portion of this README file is ripped or styled directly following
the README for kickstart.nvim.

nightowl-parliament.nvim is an experimental configuration for neovim, which is
designed with the express goal of giving neovim the capabilities to do anything
that I might ask of it as a text editor. This means it is

- large
- documented to a moderate degree
- modular to a fault

This repo is **not** meant to be used by **YOU** to begin your Neovim journey;
instead it is a personal exploration of determining what exactly neovim could
and could not be configured to achieve (within reason, of course). If you
choose to use this configuration, please be aware of the following:

- Minimalism is an Anti-Goal
- Many plugins overlap in functionality, effectively stepping on each others
  toes.
- It is unlikely that this configuration will ever be exceedingly performant.
  The configuration is somewhat performant, but I also have 64 gb of RAM
  installed. Perhaps in the future when I find it necessary to set up a laptop
  system, I will seek to improve the performance bottlenecks
- Symbol fonts and mathematically oriented iconography support is required...I
  will not be identifying "nerdfont-alternatives" for this configuration
- This configuration only targets Linux (Arch, in my case---sorry), and
  generally should only be expected to work on the most recent forms of neovim
  available, i.e. nightly builds.
- This configuration is an advanced look at using lazy.nvim for managing the
  setup, and if any of this is new to you, then you should consider at least
  reading the relevant documentation for the following, in this order:
  - Kickstart.nvim
  - LazyVim
  - Neovim
  - Vim
- This configuration has somewhat stabilized with the inclusion of ~400 plugins.

Distribution Alternatives:

- [LazyVim](https://www.lazyvim.org/): A delightful distribution maintained by
  @folke (the author of lazy.nvim, the package manager used here)
- [Kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim), a minimal base
  configuration for lazy.nvim

### Installation

> **NOTE** > [Backup](#faq) your previous configuration (if any exists)

**_Suggestions and Tips:_**

- Make sure to review the readmes of the plugins if you are experiencing errors.
- That's the only tip I have for you...

```sh
git clone https://github.com/bbjornstad/nightowl.nvim.git
"${XDG_CONFIG_HOME:-$HOME/.config}"/nvim
```

### Post Installation

Start Neovim

```sh
nvim
```

The `Lazy` plugin manager will start automatically on the first run and install
the configured plugins. Initial installation of several plugins will fail on
account of the requisite `build` step not being properly initialized on the
first clone of plugin repositories. Once the first Lazy installation is
finished, you can restart neovim in the same fashion, and the required plugins
should now succeed installation. If it continues to fail, try restarting neovim
repeatedly. If there are still problems you can try crying instead.

If you would prefer to hide this step and run the plugin sync from the command
line, you can use:

```sh
nvim --headless "+Lazy! sync" +qa
```

### Recommended Steps

[Fork](https://docs.github.com/en/get-started/quickstart/fork-a-repo) this repo
(so that you have your own copy that you can modify) and then installing you can
install to your machine using the methods above.

> **NOTE**
> Your fork's url will be something like this:
> `https://github.com/<your_github_username>/nightowl.nvim.git`

### Configuration And Extension

- Inside your copy, feel free to modify any file you like! It's your copy!
- Feel free to change any of the default options in `init.lua` to better suit
  your needs.
- For adding plugins, there are 3 primary options:
  - Add new configuration in `lua/custom/plugins/*` files, which will be auto
    sourced using `lazy.nvim` (uncomment the line importing the `custom/plugins`
    directory in the `init.lua` file to enable this)
  - Modify `init.lua` with additional plugins.
  - Include the `lua/kickstart/plugins/*` files in your configuration.

You can also merge updates/changes from the repo back into your fork, to keep
up-to-date with any changes for the default configuration.

I cannot make any promises that I won't create a merge conflict with my own
configuration though./

#### Example: Adding an autopairs plugin

In the file: `lua/custom/plugins/autopairs.lua`, add:

```lua
-- File: lua/custom/plugins/autopairs.lua

return {
  "windwp/nvim-autopairs",
  -- Optional dependency
  dependencies = { "hrsh7th/nvim-cmp" },
  config = function()
    require("nvim-autopairs").setup({})
    -- If you want to automatically add `(` after selecting a function or method
    local cmp_autopairs = require("nvim-autopairs.completion.cmp")
    local cmp = require("cmp")
    cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
  end,
}
```

This will automatically install
[windwp/nvim-autopairs](https://github.com/windwp/nvim-autopairs) and enable it
on startup. For more information, see documentation for
[lazy.nvim](https://github.com/folke/lazy.nvim).

You shouldn't need to do much, chances are I've already found the plugin you are
thinking about installing, out of 400 the odds are at least better than average.

#### Example: Adding a file tree plugin

In the file: `lua/custom/plugins/filetree.lua`, add:

```lua
-- Unless you are still migrating, remove the deprecated commands from v1.x
vim.cmd([[ let g:neo_tree_remove_legacy_commands = 1 ]])

return {
  "nvim-neo-tree/neo-tree.nvim",
  version = "*",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
    "MunifTanjim/nui.nvim",
  },
  config = function()
    require("neo-tree").setup({})
  end,
}
```

This will install the tree plugin and add the command `:Neotree` for you. You
can explore the documentation at
[neo-tree.nvim](https://github.com/nvim-neo-tree/neo-tree.nvim) for more
information.

### FAQ

- What should I do if I already have a pre-existing neovim configuration?
  - You should back it up, then delete all files associated with it.
  - This includes your existing init.lua, and the neovim files in `~/.local`
    which can be deleted with `rm -rf ~/.local/share/nvim/`
  - You may also want to look at the [migration guide for lazy.nvim](https://github.com/folke/lazy.nvim#-migration-guide)
- Can I keep my existing configuration in parallel to nightowl-parliament?

  - Yes! You can use
    [NVIM_APPNAME](https://neovim.io/doc/user/starting.html#%24NVIM_APPNAME)`=nvim-NAME`
    to maintain multiple configurations. For example, you can install the
    nightowl configuration in `~/.config/nvim-nightowl` and create an alias:

    ```shell
    alias nvim-nightowl='NVIM_APPNAME="nvim-nightowl" nvim'
    ```

    When you run Neovim using `nvim-nightowl` alias it will use the alternative
    config directory and the matching local directory
    `~/.local/share/nvim-nightowl`. You can apply this approach to any Neovim
    distribution that you would like to try out.

- What if I want to "uninstall" this configuration:
  - See [lazy.nvim uninstall](https://github.com/folke/lazy.nvim#-uninstalling) information
  - but now, why would you want to do such a thing.

### Windows Installation

Installation may require installing build tools, and updating the run command
for `telescope-fzf-native`

See `telescope-fzf-native` documentation for [more details](https://github.com/nvim-telescope/telescope-fzf-native.nvim#installation)

This requires:

- Install CMake, and the Microsoft C++ Build Tools on Windows

```lua
{
  'nvim-telescope/telescope-fzf-native.nvim',
  <!--markdownlint-disable-next-line-->
  build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build',
}
```

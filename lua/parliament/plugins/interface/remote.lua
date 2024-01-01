local key_remote = require("environment.keys").tool.remote

return {
  {
    "miversen33/netman.nvim",
    config = function(_, opts)
      require("netman").setup(opts)
    end,
    event = "VeryLazy",
  },
  {
    "chipsenkbeil/distant.nvim",
    branch = "v0.3",
    config = function(_, opts)
      require("distant"):setup(opts)
    end,
    cmd = {
      "Distant",
      "DistantLaunch",
      "DistantCheckHealth",
      "DistantInstall",
      "DistantOpen",
      "DistantClientVersion",
      "DistantConnect",
      "DistantCopy",
      "DistantMetadata",
      "DistantMkdir",
      "DistantRemove",
      "DistantSearch",
      "DistantSessionInfo",
      "DistantShell",
      "DistantSpawn",
      "DistantSystemInfo",
    },
    opts = {
      manager = {
        daemon = false,
        lazy = true,
      },
      network = {
        private = false,
        timeout = {
          max = 20000,
          interval = 256,
        },
      },
      servers = {
        ["*"] = {
          connect = {
            default = {
              scheme = "ssh",
              username = "ursa-major",
            },
          },
          launch = {
            default = {
              scheme = "ssh",
              username = "ursa-major",
            },
          },
        },
      },
    },
    keys = {},
  },
  {
    "nosduco/remote-sshfs.nvim",
    cmd = {
      "RemoteSSHFSConnect",
      "RemoteSSHFSDisconnect",
      "RemoteSSHFSEdit",
      "RemoteSSHFSFindFiles",
      "RemoteSSHFSLiveGrep",
    },
    opts = {
      connections = {
        ssh_connections = {
          vim.fn.expand("$HOME" .. ".ssh/config"),
          "/etc/ssh/ssh_config",
        },
      },
      ui = {
        select_prompts = true,
        confirm = {
          connect = true,
          change_dir = false,
        },
      },
      log = {
        enable = true,
        truncate = false,
        types = {
          all = true,
          util = true,
          handler = true,
          sshfs = true,
        },
      },
    },
    keys = {
      {
        key_remote.sshfs.connect,
        "<CMD>RemoteSSHFSConnect<CR>",
        mode = "n",
        desc = "remote:| |=> connect to sshfs",
      },
      {
        key_remote.sshfs.edit,
        "<CMD>RemoteSSHFSEdit<CR>",
        mode = "n",
        desc = "remote:| |=> edit files in sshfs",
      },
      {
        key_remote.sshfs.disconnect,
        "<CMD>RemoteSSHFSDisconnect<CR>",
        mode = "n",
        desc = "remote:| |=> disconnect from sshfs",
      },
      {
        key_remote.sshfs.find_files,
        "<CMD>RemoteSSHFSFindFiles<CR>",
        mode = "n",
        desc = "remote:| |=> find files in sshfs",
      },
      {
        key_remote.sshfs.live_grep,
        "<CMD>RemoteSSHFSLiveGrep<CR>",
        mode = "n",
        desc = "remote:| |=> live grep in sshfs",
      },
    },
  },
}

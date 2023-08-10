local key_remote = require("environment.keys").stems.remote

return {
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
        key_remote .. "sc",
        "<CMD>RemoteSSHFSConnect<CR>",
        mode = "n",
        desc = "remote=> connect to sshfs",
      },
      {
        key_remote .. "se",
        "<CMD>RemoteSSHFSEdit<CR>",
        mode = "n",
        desc = "remote=> edit files in sshfs",
      },
      {
        key_remote .. "sd",
        "<CMD>RemoteSSHFSDisconnect<CR>",
        mode = "n",
        desc = "remote=> disconnect from sshfs",
      },
      {
        key_remote .. "sf",
        "<CMD>RemoteSSHFSFindFiles<CR>",
        mode = "n",
        desc = "remote=> find files in sshfs",
      },
      {
        key_remote .. "sg",
        "<CMD>RemoteSSHFSLiveGrep<CR>",
        mode = "n",
        desc = "remote=> live grep in sshfs",
      },
    },
  },
}

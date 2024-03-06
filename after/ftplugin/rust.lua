local key_rust = require("environment.keys").lang.rust
local mapx = vim.keymap.set
local mapn = function(lhs, rhs, opts)
  mapx("n", lhs, rhs, opts)
end
local omapx = function(mode, lhs, rhs, opts)
  opts = opts or {}
  local descmap = {
    class = opts.class or "",
    family = opts.family or "",
    label = opts.label or "",
  }
  opts.class = nil
  opts.family = nil
  opts.label = nil
  opts = vim.tbl_deep_extend("force", {
    desc = string.format(
      "%s:rust| %s |=> %s",
      descmap.class,
      descmap.family,
      descmap.label
    ),
    remap = false,
    buffer = 0,
  })
  mapx(mode, lhs, rhs, opts)
end
local omapn = function(lhs, rhs, opts)
  omapx("n", lhs, rhs, opts)
end

omapn(key_rust.led.debuggable, function()
  vim.cmd.RustLSP("debuggables")
end, { class = "debug", family = "debuggable", label = "open" })

omapn(key_rust.led.runnable, function()
  vim.cmd.RustLSP("runnables")
end, { class = "run", family = "runnable", label = "open" })

omapn(key_rust.led.testable, function()
  vim.cmd.RustLSP("testables")
end, { class = "test", family = "testable", label = "open" })

omapn(key_rust.led.macro.expand, function()
  vim.cmd.RustLSP("expandMacro")
end, { class = "code", family = "macro", label = "expand recursive" })

omapn(key_rust.led.macro.rebuild, function()
  vim.cmd.RustLSP("rebuildProcMacros")
end, { class = "code", family = "macro", label = "rebuild" })

omapn(key_rust.led.action.grouped, function()
  vim.cmd.RustLSP("codeAction")
end, { class = "code", family = "action", label = "open" })

omapn(key_rust.led.action.hover, function()
  vim.cmd.RustLSP({ "hover", "actions" })
end, { class = "code", family = "action", label = "hover" })

omapn(key_rust.led.diagnostic.explain, function()
  vim.cmd.RustLSP("explainError")
end, { class = "diag", family = "error", label = "explain" })

omapn(key_rust.led.diagnostic.render, function()
  vim.cmd.RustLSP("explainError")
end, { class = "diag", family = "all", label = "render" })

omapn(key_rust.led.diagnostic.fly_check, function()
  vim.cmd.RustLSP("flyCheck")
end, { class = "diag", family = "check", label = "clippy" })

omapn(key_rust.led.crates.open_cargo, function()
  vim.cmd.RustLSP("openCargo")
end, { class = "crate", family = "cargo", label = "open" })

omapn(key_rust.led.parent, function()
  vim.cmd.RustLSP("parentModule")
end, { class = "code", family = "module", label = "parent" })

omapn(key_rust.led.symbol.workspace, function()
  vim.cmd.RustLSP("workspaceSymbol")
end, { class = "lsp", family = "symbol", label = "workspace" })

omapn(key_rust.led.symbol.workspace_filtered, function()
  vim.cmd.RustLSP("workspaceSymbol")
end, { class = "lsp", family = "symbol", label = "filtered" })

omapn(key_rust.led.join_lines, function()
  vim.cmd.RustLSP("joinLines")
end, { class = "tool", family = "lines", label = "join" })

omapn(key_rust.led.search.replace, function()
  vim.cmd.RustLSP("ssr")
end, { class = "sx", family = "replace", label = "structural" })

omapn(key_rust.led.search.query, function()
  vim.cmd.RustLSP("ssr")
end, { class = "sx", family = "replace", label = "query" })

omapn(key_rust.led.view.syntax_tree, function()
  vim.cmd.RustLSP("syntaxTree")
end, { class = "view", family = "tree", label = "syntax" })

omapn(key_rust.led.crates.graph, function()
  vim.cmd.RustLSP({ "crateGraph", "[backend]", "[output]" })
end, { class = "view", family = "crate", label = "graph" })

omapn(key_rust.led.view.hir, function()
  vim.cmd.RustLSP({ "view", "hir" })
end, { class = "view", family = "ir", label = "hir" })

omapn(key_rust.led.view.mir, function()
  vim.cmd.RustLSP({ "view", "mir" })
end, { class = "view", family = "ir", label = "mir" })

omapn(key_rust.led.view.unpretty.hir, function()
  vim.cmd.RustLSP({ "unpretty", "hir" })
end, { class = "view", family = "ir", label = "unpretty hir" })

omapn(key_rust.led.view.unpretty.mir, function()
  vim.cmd.RustLSP({ "unpretty", "mir" })
end, { class = "view", family = "ir", label = "unpretty mir" })

omapn(key_rust.led.view.memory_layout, function()
  local fn = require("ferris.methods.view_memory_layout")
  fn()
end, { class = "view", family = "mem", label = "layout" })

omapn(key_rust.led.docs.view, function()
  local fn = require("ferris.methods.open_documentation")
  fn()
end, { class = "view", family = "ir", label = "unpretty hir" })

omapn(key_rust.led.view.item_tree, function()
  local fn = require("ferris.methods.view_item_tree")
  fn()
end, { class = "view", family = "tree", label = "item" })

omapn(key_rust.led.reload, function()
  local fn = require("ferris.methods.reload_workspace")
  fn()
end, { class = "code", family = "space", label = "reload" })

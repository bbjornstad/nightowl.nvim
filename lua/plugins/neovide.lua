local mod = {}

-- We can do anything that we need to in order to set up neovide behavior
-- correctly in this block, but we need to keep the guard such that in case of
-- issues the terminal official binary will work corrctly (`nvim` on cli)
if vim.g.neovide then
  -- font setup.
  vim.o.guifont =
    "Monaspace\\ Argon,Lilex,IntelOne\\ Mono,Martian\\ Mono,Lekton,Fira\\ Mono,JuliaMono,Maple\\ Mono,Broot\\ Icons\\ Visual\\ Studio\\ Code,Symbola,codicon:h12"

  -- padding
  vim.g.neovide_padding_top = 1
  vim.g.neovide_padding_bottom = 1
  vim.g.neovide_padding_right = 1
  vim.g.neovide_padding_left = 1

  -- refresh rate
  vim.g.neovide_refresh_rate = 144
  vim.g.neovide_refresh_rate_idle = 10

  -- floating window blur
  vim.g.neovide_floating_blur_amount_x = 4.0
  vim.g.neovide_floating_blur_amount_y = 5.0
  vim.g.neovide_transparency = 0.98

  -- behavior
  vim.g.neovide_confirm_quit = true
  vim.g.neovide_hide_mouse_when_typing = false

  -- animations
  vim.g.neovide_scroll_animation_length = 0.2
  vim.g.neovide_cursor_animation_length = 0.1
  vim.g.neovide_cursor_trail_size = 0.8
  vim.g.neovide_cursor_antialiasing = true
  vim.g.neovide_cursor_animate_in_insert_mode = true
  vim.g.neovide_cursor_animate_command_line = true

  vim.g.neovide_cursor_vfx_mode = "wireframe"
  vim.g.neovide_cursor_vfx_opacity = 250
  vim.g.neovide_cursor_vfx_particle_lifetype = 1.1
  vim.g.neovide_cursor_vfx_particle_density = 10
  vim.g.neovide_cursor_vfx_particle_speed = 20
  vim.g.neovide_cursor_unfocused_outline_width = 0.125
end

return mod

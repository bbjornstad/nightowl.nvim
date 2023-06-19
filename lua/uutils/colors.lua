# vim: set ft=nu:
# vim: set modeline:

def printcolors [] {
  for $color-offset in [30 40 90 100] {
    for $color in 0..9 {
      if $color != 8 { # 8 is not a color code
        for $style in 1..9 {
          build-string $"\e[($color + $color-offset);($style)m" $'\e[($color + $color-offset)($style)m' "\e[0m"
        } | str collect
      }
    } | flatten
  } | flatten
}

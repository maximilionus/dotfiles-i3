Personal configurations for i3 Window Manager and other components.

SUPPORTED SYSTEMS
    Debian
    Arch

INSTALL
    Firstly install all the required packages:
        (debian) # xargs -a packages.txt apt install --
        (arch)   # cat pkglist.txt | pacman -S --needed --

    After that apply the configurations using GNU Stow:
        $ stow <dir>

REQUIREMENTS
    Configurations here are very heavily reliant on the main dotfiles repository
    and will not work properly without the following configuration packages:
        bash || zsh
        x11-xinit-modular-xresources

WALLPAPER
    Wallpaper is automatically loaded from this path:
        ~/Pictures/wallpaper

    PNG format is preferred since it's the only way to put a wallpaper on a lock
    screen without additional processing.

EXTENDED CONTROLS
    Mod key (mod)                            - Meta (Win)
    Execute                                  - mod + Tab
    Open terminal                            - mod (+ Shift) + Enter
      ^ Hold Shift to open in the same directory as focused window.
    Power menu                               - mod + Delete
    Screen lock                              - mod + Escape
    Split mode                               - mod + e
    Tabbed mode                              - mod (+ Shift) + w
      ^ Hold Shift for Stacking mode
    Floating mode switch                     - mod + f
    Floating focus switch                    - Alt + Tab
    Kill focused window                      - mod (+ Shift) + q
      ^ Hold Shift to send SIGKILL (-9)
    Resize focused window left/down/up/right - mod (+ Shift) + y/u/i/o
      ^ Hold Shift for precise resize
    Full-screen mode switch                  - mod + m
    Always-on-top mode                       - mod + s
    Set workspace layer                      - mod + <F1..F9>
    Reset workspace layer                    - mod + `
    Tile horizontal split                    - mod + g
    Tile vertical split                      - mod + v
    Cancel tile split                        - mod + c
    Screenshot (Selection to clibboard)      - Print
    Screenshot (Full screen to clipboard)    - Shift + Print
    Screenshot (Full screen to file)         - Control + Shift + Print

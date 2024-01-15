## About
Minimalistic and lightweight i3 window manager configuration

## Requirements
### Packages
- `i3`- window manager **[required]**
- `picom` - compositor
- `polybar` - custom top bar
- `rofi` - launcher
- `dunst` - notifications daemon
- `feh` - wallpaper utility
- `brightnessctl` - control display brightness
- `redshift` - adjusts the color temperature of screen
- `thunar`, `thunar-volman`, `gvfs`, `gvfs-afc`, `gvfs-mtp` - lightweight gui file manager and daemon for automatic removable devices management
- `maim`, `xclip` - screenshots, copy to clipboard
- `unclutter` - auto-hide mouse cursor
- `playerctl` - unified MPRIS media playback control

### Fonts
#### Families
This project uses 3 custom font families to assign the fonts. Any NerdFonts patched font will work (required mostly for the icons and powerline symbols).

- `i3_font_main` - main font, used in i3wm itself
- `i3_font_bar` - font for top bar (polybar, i3status, etc.)
- `i3_font_launcher` - font for application launcher (rofi, dmenu, etc.)

#### Configure
The [installer script](./install.sh) will copy the font configuration from `fontconfig/*` to `~/.config/fontconfig/conf.d/` of the current user. Default configuration uses the **MesloLGSDZ Nerd Font** by default, but you are free to use whatever supported font you want.

> **Note**  
> Some applications, especially the sandboxed ones (flatpak, etc.), may not be able to read user fontconfig. To fix this issue, move the configuration files from `~/.config/fontconfig/conf.d/` to system-wide `/etc/fonts/conf.d/`, or allow the sandbox to access the user configuration.  
> Flatpak fix: `flatpak --user override --filesystem=~/.config/fontconfig:ro`

## Install
1. Install the requirements.
2. Prepare the fonts.
3. Prepare the `.xinitrc` script or any Desktop Manager to start the x11 **i3** session.
4. Run the `install.sh` script. It will **copy** all configurations to a required location. You can safely remove the cloned repository after a successful install.
5. Start **i3**.

## Keys
| Command | Bind |
| :------ | :--: |
| Meta key | Win/Meta |
| Lock session | meta+Esc |
| Kill Xorg session | meta+Shift+Del |
| Horizontal layout | meta+G |
| Vertical layout | meta+V |
| Move window | meta + h,j,k,l |
| Resize active window | meta + y,u,i,o |
| Floating mode switch for active window | meta+Ctrl+F |
| Switch focus floating<->tiled | meta+Alt+F |
| Screenshot (Selection to buffer) | PrtSc |
| Screenshot (Selection to file) | meta+PrtSc |
| Screenshot (Full desktop to file) | meta+Shift+PrtSc |
| Display brightness | Fn keys |
| Media playback | Fn keys |

## Keyboard Layout
This repository does not provide any keyboard layout configuration. It's expected to be set by user through the **xorg xinit** configuration files.

**Example configuration:**
  `/etc/X11/xinit/xinitrc.d/10-keyboard-layout.sh`
```sh
##!/bin/sh

setxkbmap -layout us,jp
setxkbmap -option 'grp:win_space_toggle'
```

## Wallpaper
**feh** will try to load any image placed on path `~/.local/share/wallpaper*` automatically on **i3** start.

## Modules
This section contains detailed explanation for some custom components of this project.

#### Polybar
###### Playback control
Playback control uses the `playerctl` to work with [MPRIS](https://wiki.archlinux.org/title/MPRIS)-compliant applications. Module automatically fetches the current playback status and meta information and displays it in the status bar.

**Controls:**
| Command | Bind |
| :------ | :---: |
| Pause/Play | Left Mouse Button |
| Switch simplified mode | Right Mouse Button |
| Skip 10 seconds | Mouse Scroll Down |
| Go 10 seconds back | Mouse Scroll Up |

## Lock
Session lock uses the default `i3lock` and `xset dpms`. Be aware that it does not integrate with any Desktop Manager.

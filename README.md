# Requirements
## Packages
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

## Install
1. Install the requirements.
2. Run the `install.sh` script. It will **link** all configurations to a required location. Be aware, that you **can not delete or move** the current directory.
3. Prepare the `.xinitrc` script or any Desktop Manager to start the x11 **i3** session.
4. Configure the required fonts.
5. Start **i3**.

## Keys
| Command | Bind |
| :------ | :--: |
| Meta | Win/Meta |
| Lock session | meta+Esc |
| Horizontal layout | meta+G |
| Vertical layout | meta+V |
| Move window | meta + h,j,k,l |
| Resize active window | meta + y,u,i,o |
| Screenshot (Selection to buffer) | PrtSc |
| Screenshot (Selection to file) | meta+PrtSc |
| Screenshot (Full desktop to file) | meta+Shift+PrtSc |
| Display brightness | Fn keys |
| Media playback | Fn keys |

## Fonts
Any NerdFonts patched font assigned to monospace with fontconfig will work. Required mostly for the icons and powerline symbols.

- Example configuration
```xml
<?xml version="1.0"?>
<!DOCTYPE fontconfig SYSTEM "urn:fontconfig:fonts.dtd">
<fontconfig>
    <alias>
        <family>monospace</family>
        <prefer><family>MesloLGSDZ Nerd Font</family></prefer>
    </alias>
</fontconfig>
```

## Wallpaper
**feh** will try to load any image placed on path `~/.local/share/wallpaper*` automatically on **i3** start.

## Lock
Session lock uses the default `i3lock` and `xset dpms`. Be aware that it does not integrate with any Desktop Managers.

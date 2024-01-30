## About
Minimalistic and lightweight i3 window manager configuration


## Requirements
### Packages
- `i3`- Window manager **[required]**
- `picom` - Compositor
- `polybar` - Custom top bar
- `rofi` - Launcher
- `dunst` - Notifications daemon
- `feh` - Wallpaper utility
- `xss-lock` - Automatic session lock on suspend
- `brightnessctl` - Control display brightness
- `redshift` - Adjusts the color temperature of screen
- `thunar`, `thunar-volman`, `gvfs`, `gvfs-afc`, `gvfs-mtp` - Lightweight gui file manager and daemon for automatic removable devices management
- `maim`, `xclip` - Screenshots, copy to clipboard
- `unclutter` - Auto-hide mouse cursor
- `playerctl` - Unified MPRIS media playback control

### Fonts
While the main font configuration is very flexible, it still requires the **Noto Sans** and **Noto Sans CJK** fonts as a fallback for some characters and should therefore be available on the system.


## Fonts
### Families
This project uses 3 custom font families to assign the fonts. Any NerdFonts patched font will work (required mostly for the icons and powerline symbols).

- `i3_font_main` - main font, used in i3wm itself
- `i3_font_bar` - font for top bar (polybar, i3status, etc.)
- `i3_font_launcher` - font for application launcher (rofi, dmenu, etc.)

### Configure
The [installer script](./install.sh) will copy the font configuration from `fontconfig/*` to `~/.config/fontconfig/conf.d/` of the current user. Default configuration uses the **MesloLGSDZ Nerd Font** by default, but you are free to use whatever supported font you want.

> **Note**  
> Some applications, especially the sandboxed ones (flatpak, etc.), may not be able to read user fontconfig. To fix this issue, move the configuration files from `~/.config/fontconfig/conf.d/` to system-wide `/etc/fonts/conf.d/`, or allow the sandbox to access the user configuration.


## Install
1. Install the requirements.
2. Prepare the fonts.
3. Prepare the `.xinitrc` script or any Desktop Manager to start the x11 **i3** session.
4. Clone this repository with **git** (preferred for updates pulling) or download the source code archive.
5. Run the [installer script](./install.sh) script. It will **copy** all configurations to a required location. Keep the cloned repository after a successful install if you want to pull the updates from time to time.
6. Start **i3**.


## Update
### Original
How to update the unmodified configuration.

1. Pull changes with **git**:
```sh
$ git pull
```

2. Run the installer script again to apply the changes:
```sh
$ ./install.sh
```

3. Restart the shell.


### Modified
It is expected that you'll use **git** to make a new branch (`local` in this example) for applying the tweaks and commit all the changes to this `local` branch. Follow the steps below to apply the updates to it.

1. Pull changes with **git** (`origin` - Expected to be the original repository, not forks):
```sh
$ git pull origin
```

2. Merge the remote `master` branch into `local` and confirm the new merge-commit message:
```sh
$ git merge origin/master local
```

3. Run the installer script again to apply the changes:
```sh
$ ./install.sh
```

4. Restart the shell.


## Keys
| Command | Bind |
| :------ | :--: |
| Meta key | Win / Meta |
| Lock session | **meta** + <kbd>Esc</kbd> |
| Kill Xorg session | **meta** + <kbd>Shift</kbd> + <kbd>Del</kbd> |
| Horizontal layout | **meta** + <kbd>G</kbd> |
| Vertical layout | **meta** + <kbd>V</kbd> |
| Switch active window | **meta** + <kbd>h</kbd>,<kbd>j</kbd>,<kbd>k</kbd>,<kbd>l</kbd> |
| Move active window | **meta** + <kbd>Shift</kbd> + <kbd>h</kbd>,<kbd>j</kbd>,<kbd>k</kbd>,<kbd>l</kbd> |
| Resize active window | **meta** + <kbd>y</kbd>,<kbd>u</kbd>,<kbd>i</kbd>,<kbd>o</kbd> |
| Floating mode switch for active window | **meta** + <kbd>Ctrl</kbd> + <kbd>F</kbd> |
| Switch focus floating<->tiled | **meta** + <kbd>Alt</kbd> + <kbd>F</kbd> |
| Screenshot (Selection to buffer) | <kbd>PrtSc</kbd> |
| Screenshot (Selection to file) | **meta** + <kbd>PrtSc</kbd> |
| Screenshot (Full desktop to file) | **meta** + <kbd>Shift</kbd> + <kbd>PrtSc</kbd> |
| Display brightness | Fn keys |
| Media playback | Fn keys |


## Keyboard Layout
This repository does not provide any keyboard layout configuration. It's expected to be set by user through the **xorg xinit** configuration files.

**Example configuration:**
  `/etc/X11/xinit/xinitrc.d/10-keyboard-layout.sh`
```sh
#!/bin/sh

setxkbmap -layout us,jp
setxkbmap -option 'grp:win_space_toggle'
```


## Wallpaper

On the first launch, set the wallpaper with this command:
```sh
$ feh --bg-fill <PATH_TO_WALLPAPER>
```

And then **feh** will load the previous wallpaper automatically on each **i3** start, using the `~/.fehbg` script. Be aware, that the wallpaper file should always exist on the provided with `<PATH_TO_WALLPAPER>` path.

To change the wallpaper you only need to execute the previous command with a new path.


## Modules
This section contains detailed explanation for some custom components of this project.

### Polybar
##### Playback control
Playback control uses the `playerctl` to work with [MPRIS](https://wiki.archlinux.org/title/MPRIS)-compliant applications. Module automatically fetches the current playback status and meta information and displays it in the status bar.

**Controls:**
| Command | Bind |
| :------ | :---: |
| Pause/Play | Left Mouse Button |
| Switch simplified mode | Right Mouse Button |
| Go next | Mouse Scroll Down |
| Go previous | Mouse Scroll Up |


## Lock
Session lock uses the default `i3lock` and `xset dpms`. Be aware that it does not integrate with any Desktop Manager.

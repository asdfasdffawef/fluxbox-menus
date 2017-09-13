# fluxbox-menus
Create menus for fluxbox from .desktop files. https://www.freedesktop.org/wiki/Specifications/desktop-entry-spec/

## Installation

Simply copy build-fluxbox-menu.sh to where you keep scripts

## Usage

Edit build-fluxbox-menu.sh. Change CONFFILE, MENULIST, and DIRECTORIES

CONFFILE - is the menufile created by the script<br>
MENULIST - Choose what categories/submenus you want shown<br>
DIRECTORIES - Where to look for .desktop files<br>

Build the menu:

    $ build-fluxbox-menu.sh

This will create a ~/.fluxbox/menu.apps file which can be included in your ~/.fluxbox/menu file by adding;

  [submenu] (Desktop Files)
    [include] (~/.fluxbox/menu.apps)
  [end]

## Caveats

-Submenus can only be named from the desktop entry spec "categories"
-If not using debian (the update-alternatives system) x-terminal-emulator should be changed to your favourite terminal program
-Code is old old school compact double dereference hell

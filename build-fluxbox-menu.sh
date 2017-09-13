#!/bin/sh
# build-fluxbox-menu.sh
# Time-stamp: <2017-04-22 18:03:59 dwight>
#
# Dwight Davis <sivad_thgiwd@yahoo.ca>
#
# Usage: build-fluxbox-menu.sh
#
# Description: build fluxbox menu from .desktop files

IFS="$(printf ' \n\t')"
PATH=/usr/local/bin:/usr/bin:/bin
TMP=${TMP:-/tmp}
TMPDIR=${TMPDIR:-/tmp}
unset LD_PRELOAD
unset LD_LIBRARY_PATH

CONFFILE="$HOME/.fluxbox/menu.apps"
#MENULIST="Network Utility System Settings Office Graphics AudioVideo Development Math Science"
MENULIST="Settings Utility Development Education Graphics Network AudioVideo Office Other System Screensaver"
DIRECTORIES="
/usr/share/applications
/usr/share/applications/screensavers
$HOME/.local/share/applications"

for dir in $DIRECTORIES; do

    for fname in "$dir"/*.desktop; do

	[ -r $fname ] || continue

	unset NAME TYPE EXEC COMMENT CATEGORIES TERMINAL NODISPLAY PROCESS

	while read line; do

	    [ "${line#[}" != "$line" ] && [ "$PROCESS" = "true" ] && break
	    [ "$line" = "[Desktop Entry]" ] && PROCESS="true"
	    [ "$PROCESS" != "true" ] && continue

	    value=${line#*=}
	    attr=${line%%=*}

	    case "${attr}" in
		Name)
		    NAME="$value"
		    NAME=`echo $NAME | sed 's/[()]//g'`
		    ;;
		Type)
		    TYPE="$value"
		    ;;
		Exec)
		    EXEC="$value"
		    EXEC=`echo $EXEC | sed 's/ %.//g'`
		    ;;
		Comment)
		    COMMENT="$value"
		    ;;
		Categories)
		    CATEGORIES="$value"
		    ;;
		Terminal)
		    TERMINAL="$value"
		    ;;
		NoDisplay)
		    NODISPLAY="$value"
		    ;;
		OnlyShowIn)
		    ONLYSHOWIN="$value"
		    ;;
	    esac
	done < $fname

	CATEGORIES="${CATEGORIES:-Other;}"
	printf "Processing $NAME ($CATEGORIES)..."

	if [ "$NODISPLAY" != "true" ]; then
	    for i in $MENULIST; do
		if echo ";$CATEGORIES" | grep ";${i};" > /dev/null ; then
		    eval j="\$$i"
		    if [ "$TERMINAL" = "true" ]; then
			j="${j}${j:+\n}  [exec] ($NAME) {x-terminal-emulator -T \"$NAME\" -e sh -c \"$EXEC\"}"
		    else
			j="${j}${j:+\n}  [exec] ($NAME) {$EXEC}"
		    fi
		    eval $i='$j'
		    printf " added"
		fi
	    done
	    printf "\n"
	else
	    printf "skipping\n"
	fi
    done
done

for i in $MENULIST; do
    eval j="\$$i"
    j=`echo "$j" | sort`
    printf "[submenu] ($i)\n"
    printf "$j\n"
    printf "[end]\n\n"
done > "$CONFFILE"

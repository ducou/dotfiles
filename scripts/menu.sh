#!/bin/bash

# input: list of menu items
# output: item selected
# exit codes: 0 - normal, 1 - abort, 2 - no menu items, 3 - too many items
# to select item, press enter; to abort press q

function select_menu {
[[ $# -lt 1 ]] && exit 2 # no menu items, at least 1 required

[[ $# -gt $(( `tput lines` - 1 )) ]] && exit 3 # more items than rows

# set colors
cn="`echo -e '\r\e[0;1m'`" # normal
cr="`echo -e '\r\e[1;7m'`" # reverse

# keys
au="`echo -e '\e[A'`" # arrow up
ad="`echo -e '\e[B'`" # arrow down
ec="`echo -e '\e'`"   # escape
nl="`echo -e '\n'`"   # newline

tn="$#" # total number of items

{ # capture stdout to stderr

	tput civis # hide cursor

	cp=1 # current position

	end=false

	while ! $end
	do

		for i in `seq 1 $tn`
		do

			echo -n "$cn"
			[[ $cp == $i ]] && echo -n "$cr"

			eval "echo \$$i"

		done

		read -sn 1 key
		[[ "$key" == "$ec" ]] &&
			{
				read -sn 2 k2
				key="$key$k2"
			}

			case "$key" in

				"$au"|k)
					cp=$(( cp - 1 ))
					[[ $cp == 0 ]] && cp=$tn
					;;

				"$ad"|j)
					cp=$(( cp + 1 ))
					[[ $cp == $(( tn + 1 )) ]] && cp=1
					;;

				"$nl")
					si=true
					end=true
					;;

				"q")
					si=false
					end=true
					;;

			esac

			tput cuu $tn

		done

		tput cud $(( tn - 1 ))
		tput cnorm # unhide cursor
		echo "$cn" # normal colors

	} >&2 # end capture

	$si && eval "echo \$$cp"
}
# eof

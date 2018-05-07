#!/usr/bin/env bash

### ABOUT ###
# CentOS version of the adify script


echo """
==============================================================================
Installing tools for Arch....
==============================================================================
"""
pm="sudo pacman"

echo """
==========================================================
Detecting Shell type.........
==========================================================
"""
case $SHELL in
	"/bin/zsh")
	shell="zsh"
	echo """
Shell is $shell.. Adify is supported for $shell! :)
	"""
	;;
	"/bin/bash")
	shell="bash"
	echo """
Shell is $shell.. Adify is supported for $shell! :)
	"""
	;;
esac

ex_version="1.6.3"
otp_version="20.3"
asdf_version="0.4.2"

if [ ! -d "$HOME/adify" ]; then
  echo """
==========================================================
Adifying for the first time....
==========================================================
  """

  echo """
==========================================================
Fetching Adifying files...
==========================================================
  """
  git clone --depth=1 https://github.com/aditya7iyengar/adify.git "$HOME/adify"

  cd "$HOME/adify"
  [ "$1" = "ask" ] && export ADIFYASK="true"
  [ "$1" = "work" ] && export ADIFYWORK="true"

  echo """
==========================================================
Installing Asdf $asdf_version for Elixir and Erlang...
==========================================================
  """
  git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v${asdf_version}

	case $OS in
		'Mac')
		echo -e '\n. $HOME/.asdf/asdf.sh' >> ~/.${shell}rc
    echo -e '\n. $HOME/.asdf/completions/asdf.bash' >> ~/.${shell}rc
		source ~/.${shell}rc
		;;
		"\"Ubuntu\"")
		echo -e '\n. $HOME/.asdf/asdf.sh' >> ~/.${shell}rc
    echo -e '\n. $HOME/.asdf/completions/asdf.bash' >> ~/.${shell}rc
		source ~/.${shell}rc
		;;
		"\"Centos\"")
		echo -e '\n. $HOME/.asdf/asdf.sh' >> ~/.${shell}rc
    echo -e '\n. $HOME/.asdf/completions/asdf.bash' >> ~/.${shell}rc
		source ~/.${shell}rc
		;;
	esac

	chmod 777 $HOME/.asdf/asdf.sh
	chmod 777 $HOME/.asdf/completions/asdf.bash

	. $HOME/.asdf/asdf.sh
	. $HOME/.asdf/completions/asdf.bash

  echo """
==========================================================
Preparing to install ERLANG $otp_version.
Installing dependencies for ERLANG $otp_version....
==========================================================
  """
  $pm -S libwxgtk3.0-dev libgl1-mesa-dev libglu1-mesa-dev libpng3 --noconfirm
  $pm -S build-essential --noconfirm
  $pm -S autoconf --noconfirm
  $pm -S m4 --noconfirm
  $pm -S libncurses5-de --noconfirmv
  $pm -S openjdk-9-jdk fop xsltproc --noconfirm
  $pm -S libssh-dev --noconfirm
  $pm -S unixodbc-dev --noconfirm

  echo """
==========================================================
Installing ERLANG $otp_version to run Adifier app....
==========================================================
  """
  asdf plugin-add erlang https://github.com/asdf-vm/asdf-erlang.git
  asdf install erlang ${otp_version}

  echo """
==========================================================
Installing ELIXIR $ex_version to run Adifier app....
==========================================================
  """
	asdf plugin-add elixir https://github.com/asdf-vm/asdf-elixir.git
  asdf install elixir ${ex_version}

  echo """
==========================================================
Running Adifier... (mix adify)
==========================================================
  """
	cd adifier
	mix deps.get
	mix compile
  mix adify
else
  echo """
XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
The system is already Adified.
XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
  """
fi

#!/usr/bin/env bash

### ABOUT ###
# This script is responsible for running all the commands required to setup an
# Ubuntu/CentOS/MacOS computer for me to work effectively.
# In other words, it "adifies" the computer.
# This script doesn't include the tools required to do "Work" related stuff

### USAGE ###
# From the terminal:
# $ bash <(wget -qO- https://raw.githubusercontent.com/aditya7iyengar/adify/master/adify.sh)
# OR
# $ bash <(curl -s https://raw.githubusercontent.com/aditya7iyengar/adify/master/adify.sh)

# TODO: Make it runnable on other OS.
# This Script is setup to run only on Ubuntu computers


### REQUIREMENTS ###
# - Internet Connection
# - Admin Privilleges of the computer being adified
# - Adi (for credentials)

### PRELUDE ###
# Installing `curl` if not installed already
# Detecting OS
echo """
==========================================================
Detecting OS.........
==========================================================
"""
OS="`uname`"
case $OS in
  'Linux')
		OS="`nawk -F= '/^NAME/{print $2}' /etc/os-release`"
		case $OS in
		"\"Ubuntu\"")
    echo """
OS is $OS.. Adify is supported for $OS! :)
		"""
		pm="sudo apt-get"
		;;
		"\"Centos\"")
    echo """
OS is $OS.. Adify is supported for $OS! :)
		"""
		pm="sudo yum"
		;;
		esac
    ;;
  'FreeBSD')
    OS='FreeBSD'
    echo """
OS is FreeBSD.. Adify isn't supported for FreeBSD. :(
		"""
		exit 1
    ;;
  'WindowsNT')
    OS='Windows'
    echo """
OS is Windows.. Adify isn't supported for Windows. :(
		"""
		exit 1
    ;;
  'Darwin')
    OS='Mac'
    echo """
OS is Mac.. Adify is supported for Mac! :)
		"""
    pm="brew"
    ;;
  'SunOS')
    OS='Solaris'
    echo """
OS is Solaris.. Adify isn't supported for Solaris.
		"""
		exit 1
    ;;
  'AIX')
    echo """
OS is AIX.. Adify isn't supported for AIX.
		"""
		exit 1
		;;
  *)
	;;
esac


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

### CURL ###
# Install curl, as it's an important tool!!
echo """
==========================================================
Installing Curl.. Can't live without that!
==========================================================
"""
$pm install -y curl


### GIT ###
# Running all three package manager commands.
echo """
==========================================================
Installing Git to get adify.
==========================================================
"""
$pm install -y git

ex_version="1.5.2"
otp_version="20.2"
asdf_version="0.4.0"

if [ ! -d "$HOME/adify" ]; then
  echo """
==========================================================
Adifying for the first time....

This script is responsible for running all the commands required to setup an ubuntu computer
for me to work effectively. Hence, it adifies the computer.
This script doesn't include the tools required to do 'work' elated stuff by default
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
	case $OS in
		'Mac')
		xcode-select --install
		$pm install wxmac
		;;
		"\"Ubuntu\"")
		$pm -y install build-essential git wget libssl-dev libreadline-dev \
			libncurses5-dev zlib1g-dev m4 curl wx-common libwxgtk3.0-dev autoconf \
			openjdk-8-jdk fop xsltproc
		;;
		"\"Centos\"")
		$pm -y install libwxgtk3.0-dev libgl1-mesa-dev libglu1-mesa-dev libpng3
		$pm -y install build-essential
		$pm -y install autoconf
		$pm -y install m4
		$pm -y install libncurses5-dev
		$pm -y install openjdk-9-jdk fop xsltproc
		;;
	esac
	$pm -y install libssh-dev
	$pm -y install unixodbc-dev


  echo """
==========================================================
Installing ERLANG $otp_version to run Adifier app....
==========================================================
  """
	case $OS in
		"\"Ubuntu\"")
		wget https://packages.erlang-solutions.com/erlang-solutions_1.0_all.deb
		sudo dpkg -i erlang-solutions_1.0_all.deb
		sudo apt-get update
		sudo apt-get install -y erlang
		;;
		*)
		asdf plugin-add erlang https://github.com/asdf-vm/asdf-erlang.git
		asdf install erlang ${otp_version}
	esac

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


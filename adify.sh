#!/usr/bin/env bash

### ABOUT ###
# This script is responsible for running all the commands required to setup an
# Ubuntu/CentOS/MacOS computer for me to work effectively.
# In other words, it "adifies" the computer.
# This script doesn't not include the tools required to do "Work" related stuff

### USAGE ###
# From the terminal:
# $ wget -0 - https://github.com/aditya7iyengar/adify/blob/master/adify.sh | bash
# OR
# $ curl -s https://github.com/aditya7iyengar/adify/blob/master/adify.sh | bash

# TODO: Make it runnable on other OS.
# This Script is setup to run only on Ubuntu computers


### REQUIREMENTS ###
# - Internet Connection
# - Admin Privilleges of the computer being adified
# - Adi (for credentials)

### PRELUDE ###
# Installing `curl` if not installed already
# Detecting OS
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

### GIT ###
# Running all three package manager commands.
echo """
==========================================================
Installing Git to get adify.
==========================================================
"""
# TODO: Use "uname" command or "$OSTYPE" env
$pm apt-get install -y git

ex_version="1.5.2"
otp_version="20.0"
asdf_version="0.4.0"

if [ ! -d "$HOME/adify" ]; then
  echo """
==========================================================
Adifying for the first time....

This script is responsible for running all the commands required to setup an ubuntu computer
for me to work effectively. Hence, it adifies the computer.
This script doesn't not include the tools required to do 'work' elated stuff by default
==========================================================
  """

  echo """
==========================================================
Fetching Adifying files...
==========================================================
  """
  git clone --depth=1 https://github.com/aditya7iyengar/adify.git "$HOME/adify"

  cd "$HOME/.adify"
  [ "$1" = "ask" ] && export ADIFYASK="true"
  [ "$1" = "work" ] && export ADIFYWORK="true"


  echo """
==========================================================
Installing Asdf $asdf_version for Elixir and Erlang...
==========================================================
  """
  git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v${asdf_version}


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
  asdf add-plugin elixir https://github.com/asdf-vm/asdf-elixir.git
  asdf install elixir ${ex_version}

  echo """
==========================================================
Running Adifier... (mix adify)
==========================================================
  """
  mix adify
else
  echo """
XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
The system is already Adified.
XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
  """
fi


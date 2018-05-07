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
		OS="`gawk -F= '/^NAME/{print $2}' /etc/os-release`"

		case $OS in
		"\"Ubuntu\"")
      echo """
OS is $OS.. Adify is supported for $OS! :)
      """
      source "./linux/ubuntu.sh"
      pm="sudo apt-get"
      ;;
		"\"Centos\"")
      echo """
OS is $OS.. Adify is supported for $OS! :)
      """
      source ".os/linux/centos.sh"
    ;;
		"\"Fedora\"")
      echo """
OS is $OS.. Adify is supported for $OS! :)
      """
      pm="sudo yum"
      source "./linux/fedora.sh"
		;;
		"\"Arch Linux\"")
      echo """
OS is $OS.. Adify is supported for $OS! :)
      """
      source ".os/linux/arch.sh"
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


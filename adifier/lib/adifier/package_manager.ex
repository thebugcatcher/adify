defmodule Adifier.PackageManager do
  @moduledoc """
  This module's responsibility is to return command to install a given `package`
  on a given `os`, or return command to update a package manager.`Adifier.Tool`
  and `Adifier.PackageManager` delegate to this module by default.
  """

  def install_cmd(:arch_linux, pkg), do: "sudo pacman -S #{pkg} --noconfirm"
  def install_cmd(:mac, pkg), do: "brew install #{pkg}"
  def install_cmd(:debian, pkg), do: "sudo apt -y install #{pkg}"

  def install_cmd(os, pkg) when os in [:ubuntu, :pop_os] do
    "sudo apt-get -y install #{pkg}"
  end

  def install_cmd(os, pkg) when os in [:centos, :fedora] do
    "sudo yum -y install #{pkg}"
  end

  def pm_update_cmd(:arch_linux), do: "sudo pacman -Syu --noconfirm"
  def pm_update_cmd(:debian), do: "sudo apt -y update"
  def pm_update_cmd(:mac), do: "brew update"
  def pm_update_cmd(os) when os in [:ubuntu, :pop_os], do: "sudo apt-get -y update"
  def pm_update_cmd(os) when os in [:centos, :fedora], do: "sudo yum -y update"
end

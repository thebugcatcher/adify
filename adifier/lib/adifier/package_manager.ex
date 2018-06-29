defmodule Adifier.PackageManager do
  @moduledoc """
  This module's responsibility is to install a given `package` on a given
  `os`. `Adifier.Tool` delegates to this module by default.
  """

  # @needsudo ~w(apt apt-get yum pacman)
  # @needyes ~w(apt apt-get yum)
  # @cmd_opts [into: IO.stream(:stdio, :line)]

  def install_cmd(:ubuntu, pkg), do: "sudo apt-get -y install #{pkg}"
  def install_cmd(os, pkg), do: "sudo apt -y install #{pkg}"
  def install_cmd(os, pkg) when os in [:centos, :fedora] do
    "sudo yum -y install #{pkg}"
  end
  def install_cmd(:arch, pkg), do: "sudo pacman -S #{pkg} --no-confirm"
  def install_cmd(:mac, pkg), do: "brew install #{pkg}"

  # def invoke_cmd(pm, with: str) when pm in @needsudo do
  #   System.cmd("sudo", ["-A", pm | String.split(str)],
  #             [env: [{"SUDO_ASKPASS", "/usr/bin/ssh-askpass"}]] ++ @cmdopts)
  # end

  # def invoke_cmd(pm, with: str) do
  #   System.cmd(pm, String.split(str), @cmdopts)
  # end
end

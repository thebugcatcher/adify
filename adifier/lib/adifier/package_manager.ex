defmodule Adifier.PackageManager do
  @moduledoc """
  """

  @needsudo ~w(apt apt-get yum)
  @needyes ~w(apt apt-get yum)
  @cmdopts [into: IO.stream(:stdio, :line)]

  def package_managers(:ubuntu), do: ~w(apt apt-get)
  def package_managers(:centos), do: ~w(yum)
  def package_managers(:mac), do: ~w(brew)

  def invoke_cmd(pm, with: str) when pm in @needsudo do
    System.cmd("sudo", ["-A", pm | String.split(str)],
              [env: [{"SUDO_ASKPASS", "/usr/bin/ssh-askpass"}]] ++ @cmdopts)
  end
  def invoke_cmd(pm, with: str) do
    System.cmd(pm, String.split(str), @cmdopts)
  end

  def update_cmd(pm), do: invoke_cmd(pm, with: "update")

  def install_pkg(pm, pkg) when pm in @needyes, do: invoke_cmd(pm, with: "install -y #{pkg}")
  def install_pkg(pm, pkg), do: invoke_cmd(pm, with: "install #{pkg}")
end

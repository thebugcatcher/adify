defmodule Adifier.Invoker do
  @moduledoc """
  This module invokes a command with specific command options.
  """

  @cmd_opts [into: IO.stream(:stdio, :line)]

  @doc false
  def call("sudo" <> cmd = cmd) do
    System.cmd("sudo", ["-A", String.split(cmd)],
              [env: [{"SUDO_ASKPASS", "/usr/bin/ssh-askpass"}]] ++ @cmdopts)
  end
  def call(cmd) do
    System.cmd("sh -c", String.split(cmd), @cmdopts)
  end
end

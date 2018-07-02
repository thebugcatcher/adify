defmodule Adifier.Invoker do
  @moduledoc """
  This module invokes a command with specific command options.
  """

  @cmd_opts [into: IO.stream(:stdio, :line)]

  @doc false
  def call("sudo" <> cmd) do
    System.cmd("sh", ["-c" , "sudo -A #{cmd}"],
            env: [{"SUDO_ASKPASS", "./askpass.sh"}],
            into: IO.stream(:stdio, :line))
  end
  def call(cmd) do
    System.cmd("sh", ["-c", cmd], @cmdopts)
  end
end

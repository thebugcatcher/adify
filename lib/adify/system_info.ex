defmodule Adify.SystemInfo do
  @moduledoc """
  This module is used to get system's information. Information like
  OS type, Distribution, Kernel, Package Managers etc
  """

  @valid_os ~w(
    arch_linux
    debian
    osx
    pop_os
    ubuntu
  )

  @doc """
  Returns whether an OS is valid for adifying

  ## Examples

      # When os is osx
      iex> Adify.SystemInfo.valid_os?("osx")
      true

      # When os is arch_linux
      iex> Adify.SystemInfo.valid_os?("arch_linux")
      true

      # When os is ubuntu
      iex> Adify.SystemInfo.valid_os?("ubuntu")
      true

      # When os is pop_os
      iex> Adify.SystemInfo.valid_os?("ubuntu")
      true

      # When os is redox (not compatible with adify unfortunately)
      iex> Adify.SystemInfo.valid_os?("redox")
      false
  """
  @spec valid_os?(String.t()) :: boolean()
  def valid_os?(os) when os in @valid_os, do: true
  def valid_os?(_), do: false

  @doc """
  Returns the current os

  ## Examples
      # If uname returns Darwin, it's osx
      iex> {:ok, output} = Adify.SystemInfo.cmd("uname", [], ".")
      iex> (output =~ "Darwin") ==
      ...>   (Adify.SystemInfo.current_os == {:ok, "osx"})
      true

      # If uname returns Linux, it's not osx
      iex> {:ok, output} = Adify.SystemInfo.cmd("uname", [], ".")
      iex> (output =~ "Linux") ==
      ...>   (Adify.SystemInfo.current_os != {:ok, "osx"})
      true
  """
  @spec current_os :: {:ok, String.t()} | {:error, term}
  def current_os do
    {:ok, kernel} = current_kernel()

    cond do
      kernel == "Darwin" -> {:ok, "osx"}
      kernel =~ "Linux" -> current_linux_distro()
      true -> {:error, "Unsupported Kernel: #{kernel}"}
    end
  end

  defp current_linux_distro do
    {:ok, output} = cmd("cat /etc/os-release | grep ^NAME")

    cond do
      output =~ "Debian" -> {:ok, "debian"}
      output =~ "Pop!_OS" -> {:ok, "pop_os"}
      output =~ "Arch" -> {:ok, "arch_linux"}
      output =~ "Antergos" -> {:ok, "arch_linux"}
      output =~ "Manjaro" -> {:ok, "arch_linux"}
      output =~ "Ubuntu" -> {:ok, "ubuntu"}
      true -> {:error, "Unknown Linux Distro"}
    end
  end

  defp current_kernel do
    {:ok, output} = cmd("uname")

    cond do
      output =~ "Linux" -> {:ok, "Linux"}
      output =~ "Darwin" -> {:ok, "Darwin"}
      true -> {:error, "Unknown Terminal"}
    end
  end

  @doc """
  Wrapper around Elixir's System command.
  Runs a command on the CLI.

  ## Examples:

      # When the command is valid
      iex> cmd = "echo hi"
      iex> {:ok, output} = Adify.SystemInfo.cmd(cmd)
      iex> output =~ "hi"
      true

      # When the command is invalid
      iex> cmd = "bad_command"
      iex> {:error, output}  = Adify.SystemInfo.cmd(cmd, [], ".")
      iex> output =~ "bad_command"
      true
  """
  @spec cmd(String.t(), [{String.t(), String.t()}], Path.t()) ::
          {:ok, String.t()} | {:error, String.t()}
  def cmd(cmd, env \\ [], cd \\ ".") do
    case System.cmd("sh", ["-c", cmd], env: env, cd: cd, stderr_to_stdout: true) do
      {output, 0} -> {:ok, output}
      {output, _} -> {:error, output}
    end
  end
end

defmodule Adify do
  @moduledoc """
  This module is the main API to interact with Adify

  A configurable, extendable DevOps environment app. This app installs tools
  based on the given operating systems.
  """

  alias Adify.Environment

  @doc """
  Runs an adifying process

  Takes a Keyword as an argument with optional keys:

  * `:confirm`: Boolean; Specifies whether a confirmation is needed before
    updating the state of the system.
  * `:digest_file`: String, Path; Specifies the location of adify digest file
    generated after adification.
  * `:tools_dir`: String, Path; Specifies the location of the directory
    that contains files corresponding to tools, configuration files and yaml
    files that is needed for adification.
  """
  @spec run(Keyword.t()) :: {:ok, term()} | {:error, term()}
  def run(opts \\ []) do
    options = transpose_defaults(opts)

    with {:ok, environment} <- Environment.init(options),
         {:ok, environment} <- Environment.install_tools(environment),
         {:ok, digest} <- print_digest_file(environment) do
      {:ok, digest}
    else
      {:error, reason} -> {:error, reason}
    end
  end

  defp transpose_defaults(opts) do
    confirm = Keyword.get(opts, :confirm, default(:confirm))
    digest_file = Keyword.get(opts, :digest_file, default(:digest_file))
    os = Keyword.get(opts, :os, default(:os))
    tools_dir = Keyword.get(opts, :tools_dir, default(:tools_dir))

    [
      confirm: confirm,
      digest_file: digest_file,
      os: os,
      tools_dir: tools_dir
    ]
  end

  defp install(tools, options \\ []) do
    {:ok, nil}
  end

  defp print_digest_file(digest, options \\ []) do
    {:ok, nil}
  end

  @doc """
  Returns default options set for a specific key

  ## Examples

      # When the key is `:confirm`
      iex> Adify.default(:confirm)
      true

      # When the key is `:digest_file`
      iex> path = Adify.default(:digest_file)
      iex> path == Path.join([System.user_home(), ".adify", ".digest"])
      true

      # When the key is `:tools_dir`
      iex> path = Adify.default(:tools_dir)
      iex> path == Path.join(:code.priv_dir(:adify), "tools")
      true

      # When the key is `:os`
      iex> path = Adify.default(:os)
      iex> path == Adify.SystemInfo.current_os()
      true

      # When there's some other key
      iex> Adify.default(:other_key)
      nil
  """
  @spec default(atom()) :: term()
  def default(:confirm), do: true

  def default(:digest_file) do
    Path.join([System.user_home(), ".adify", ".digest"])
  end

  def default(:tools_dir), do: Path.join(:code.priv_dir(:adify), "tools")

  def default(:os), do: Adify.SystemInfo.current_os()

  def default(_), do: nil
end

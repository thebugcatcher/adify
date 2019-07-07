defmodule Adify.Environment.Operation do
  @moduledoc """
  Represents the data related to an environment operation. An environment
  operation is when a tool is attempted to be installed or uninstalled.
  """

  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  @valid_states ~w(new failed completed)

  @type t :: %__MODULE__{}

  embedded_schema do
    field(:confirmation, :boolean, default: false)
    field(:output, :string)
    field(:os, :string)
    field(:state, :string, default: "new")
    field(:started_at, :utc_datetime)
    field(:ended_at, :utc_datetime)

    embeds_one(:selected_installation_strategy, Adify.Tool.InstallationStrategy)
    embeds_one(:tool, Adify.Tool)
  end

  def changeset(struct, params) do
    struct
    |> cast(params, [:os, :output, :confirmation, :state, :started_at, :ended_at])
    |> validate_inclusion(:state, @valid_states)
    |> cast_embed(:tool)
    |> cast_embed(:selected_installation_strategy)
  end

  @doc """
  Attempts to install tool

  ## Examples:

      iex> {:ok, tool} =
      ...>   Adify.YAML.parse_and_cast("./test/support/tools/valid/201907051629/tool.yaml")
      iex> os_command = tool.os_commands
      ...>  |> Enum.find(& &1.os == "arch_linux")
      iex> strategy = os_command.installation_strategies |> Enum.find(& &1.default)
      iex> operation = %Adify.Environment.Operation{
      ...>   state: "new",
      ...>   os: "arch_linux",
      ...>   tool: tool,
      ...>   selected_installation_strategy: strategy
      ...> }
      iex> {:ok, env} = Adify.Environment.Operation.run(operation, false)
      iex> env.state == "completed"
      true
  """
  @spec run(__MODULE__.t(), boolean()) :: {:ok, term()} | {:error, term()}
  def run(%__MODULE__{} = operation, ask_for_confirmation \\ true) do
    with true <- confirmation(operation, ask_for_confirmation),
         {:ok, output} <- Adify.Tool.install(operation.tool, operation.os)
    do
      {:ok,
       %__MODULE__{
         confirmation: true,
         output: output,
         os: operation.os,
         state: "completed",
         selected_installation_strategy:
           strategy(os_command(operation.tool, for: operation.os), :default),
         tool: operation.tool
       }}
    else
      {:error, {output, _}} ->
        {:error,
         %__MODULE__{
           confirmation: true,
           output: output,
           os: operation.os,
           state: "failed",
           selected_installation_strategy:
             strategy(os_command(operation.tool, for: operation.os), :default),
           tool: operation.tool
         }}

      {:error, output} ->
        {:error,
         %__MODULE__{
           confirmation: true,
           output: output,
           os: operation.os,
           state: "failed",
           selected_installation_strategy:
             strategy(os_command(operation.tool, for: operation.os), :default),
           tool: operation.tool
         }}

      false ->
        {:ok,
         %__MODULE__{
           confirmation: false,
           output: "Not installing tool: #{operation.tool.name}",
           os: operation.os,
           state: "completed",
           selected_installation_strategy:
             strategy(os_command(operation.tool, for: operation.os), :default),
           tool: operation.tool
         }}
    end
  end

  defp confirmation(%__MODULE__{} = operation, ask_for_confirmation) do
    confirmation =
      case ask_for_confirmation do
        true ->
          operation
          |> tool_info()
          |> IO.gets()
          |> String.trim()
        false ->
          IO.puts(tool_info(operation))
          IO.puts("NOCONFIRM mode is on, so installing tool...")
          "Y"
      end

    case confirmation do
      "Y" -> true
      "y" -> true
      _ -> false
    end
  end

  defp tool_info(%__MODULE__{tool: tool, os: os}) do
    """
    Tool name: #{tool.name}
    Tool description: #{tool.description}
    Tool version: #{tool.version}
    Default Strategy: #{strategy(os_command(tool, for: os), :default)}
    Install Tool? (y/N)
    """
  end

  defp os_command(tool, for: os) do
    Enum.find(tool.os_commands, &(&1.os == os))
  end

  defp strategy(os_command, :default) do
    if os_command do
      Enum.find(os_command.installation_strategies, &(&1.default == true)).name
    else
      "NIL"
    end
  end
end

defmodule Adify.Tool do
  @moduledoc """
  Represents a Tool that can be installed/uninstalled using Adify
  """

  use Ecto.Schema
  import Ecto.Changeset

  @type t :: %__MODULE__{}

  @primary_key false

  embedded_schema do
    field(:name, :string)
    field(:version, :integer)
    field(:description, :string)

    embeds_many(:os_commands, Adify.Tool.OSCommand)
  end

  def changeset(struct, params) do
    struct
    |> cast(params, [:name, :version, :description])
    |> validate_required([:name, :version, :description])
    |> cast_embed(:os_commands, required: true)
  end

  @doc """
  Installs a tool based on a given strategy

  ## Examples:

      # When all inputs are valid
      iex> {:ok, tool} =
      ...>   Adify.YAML.parse_and_cast("./test/support/tools/valid/201907051629/tool.yaml")
      iex> {:ok, output} = Adify.Tool.install(tool, "arch_linux")
      iex> output =~ "Running Pre:" && output =~ "hello pre" &&
      ...>   output =~ "Running Main:" && output =~ "hello main" &&
      ...>   output =~ "Running Post:" && output =~ "hello post"
      true

      # When OS isn't valid
      iex> {:ok, tool} =
      ...>   Adify.YAML.parse_and_cast("./test/support/tools/valid/201907051629/tool.yaml")
      iex> Adify.Tool.install(tool, "redox")
      {:error, "Invalid OS"}

  """
  @spec install(__MODULE__.t(), String.t(), integer() | :default) ::
          {:ok, term()} | {:error, term()}
  def install(%__MODULE__{} = tool, os, strategy \\ :default) do
    with true <- Adify.SystemInfo.valid_os?(os),
         os_command when not is_nil(os_command) <- os_command(tool, for: os),
         inst when not is_nil(inst) <- strategy(os_command, strategy),
         up when not is_nil(up) <- workflow(inst, :up) do
      Adify.Tool.InstallationStrategy.Workflow.run(up)
    else
      false -> {:error, "Invalid OS"}
      nil -> {:error, "Something went wrong"}
    end
  end

  defp os_command(tool, for: os) do
    Enum.find(tool.os_commands, &(&1.os == os))
  end

  defp strategy(os_command, :default) do
    Enum.find(os_command.installation_strategies, &(&1.default == true))
  end

  defp strategy(os_command, number) do
    Enum.find(os_command.installation_strategies, &(&1.number == number))
  end

  defp workflow(strategy, :up), do: strategy.up
  defp workflow(strategy, :down), do: strategy.down

  @doc """
  Uninstalls a tool based on a given strategy

  ## Examples:

      # When all inputs are valid
      iex> {:ok, tool} =
      ...>   Adify.YAML.parse_and_cast("./test/support/tools/valid/201907051629/tool.yaml")
      iex> {:ok, output} = Adify.Tool.uninstall(tool, "arch_linux")
      iex> output =~ "Running Pre:" && output =~ "bye pre" &&
      ...>   output =~ "Running Main:" && output =~ "bye main" &&
      ...>   output =~ "Running Post:" && output =~ "bye post"
      true

      # When OS isn't valid
      iex> {:ok, tool} =
      ...>   Adify.YAML.parse_and_cast("./test/support/tools/valid/201907051629/tool.yaml")
      iex> Adify.Tool.uninstall(tool, "redox")
      {:error, "Invalid OS"}
  """
  @spec uninstall(__MODULE__.t(), String.t(), integer() | :default) ::
          {:ok, term()} | {:error, term()}
  def uninstall(%__MODULE__{} = tool, os, strategy \\ :default) do
    with true <- Adify.SystemInfo.valid_os?(os),
         os_command when not is_nil(os_command) <- os_command(tool, for: os),
         inst when not is_nil(inst) <- strategy(os_command, strategy),
         down when not is_nil(down) <- workflow(inst, :down) do
      Adify.Tool.InstallationStrategy.Workflow.run(down)
    else
      false -> {:error, "Invalid OS"}
      nil -> {:error, "Something went wrong"}
    end
  end
end

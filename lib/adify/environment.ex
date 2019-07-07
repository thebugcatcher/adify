defmodule Adify.Environment do
  @moduledoc """
  Represents the structure of an adification process. This represents the state
  of the system, intended state of the system and processes ran during
  adification.
  """

  use Ecto.Schema
  import Ecto.Changeset

  @type t :: %__MODULE__{}

  @primary_key false
  @valid_states ~w(new processing failed completed)

  embedded_schema do
    field(:os, :string)
    field(:confirm, :boolean, default: true)
    field(:digest_file, :string)
    field(:tools_dir, :string)
    field(:state, :string, default: "new")
    field(:started_at, :utc_datetime)
    field(:ended_at, :utc_datetime)
    field(:meta, :map, default: %{})

    embeds_many(:operations, Adify.Environment.Operation)
    embeds_many(:tools, Adify.Tool)
  end

  def changeset(struct, params) do
    struct
    |> cast(params, [
      :os,
      :confirm,
      :digest_file,
      :tools_dir,
      :state,
      :started_at,
      :ended_at,
      :meta
    ])
    |> validate_required([:os, :digest_file, :tools_dir, :started_at])
    |> validate_inclusion(:state, @valid_states)
    |> cast_embed(:tools)
    |> cast_embed(:operations)
  end

  @doc """
  Initializes an Environment struct

      ## Examples
      # When invalid options are given
      iex> options = [
      ...>   confirm: true,
      ...>   digest_file: ".temp.dump",
      ...>   tools_dir: "./test/support/tools/",
      ...>   os: "arch_linux"
      ...> ]
      iex> {:ok, tool} =
      ...>   Adify.YAML.parse_and_cast("./test/support/tools/valid/201907051629/tool.yaml")
      iex> tools = [tool]
      iex> {:ok, env} = Adify.Environment.init(options)
      iex> env.confirm == true && env.ended_at == nil && env.state == "new" &&
      ...>  env.meta == %{} && env.tools == tools
      true

      # When invalid options are given
      iex> options = [
      ...>   confirm: true,
      ...>   digest_file: ".temp.dump",
      ...>   tools_dir: "./test/support/tools/"
      ...> ]
      iex> Adify.Environment.init(options)
      {:error, [os: {"can't be blank", [validation: :required]}]}
  """
  @spec init(Keyword.t()) :: {:ok, __MODULE__.t()} | {:error, term()}
  def init(opts \\ []) do
    with {:ok, tools} <- load_all_tools(Keyword.get(opts, :tools_dir)),
         {:ok, env} <- init_with_tools(opts, tools) do
      {:ok, env}
    else
      {:error, reason} -> {:error, reason}
    end
  end

  @doc """
  Installs all tools and returns the updated environment

  ## Examples:

      # When tool is valid
      iex> options = [
      ...>   confirm: false,
      ...>   digest_file: ".temp.dump",
      ...>   tools_dir: "./test/support/tools/",
      ...>   os: "arch_linux"
      ...> ]
      iex> {:ok, tool} =
      ...>   Adify.YAML.parse_and_cast("./test/support/tools/valid/201907051629/tool.yaml")
      iex> tools = [tool]
      iex> {:ok, env} = Adify.Environment.init(options)
      iex> true = env.state == "new" && Enum.empty?(env.operations)
      iex> {:ok, env} = Adify.Environment.install_tools(env)
      iex> env.state == "completed" && !Enum.empty?(env.operations)
      true
  """
  @spec install_tools(__MODULE__.t()) :: {:ok, term()} | {:error, term()}
  def install_tools(%__MODULE__{} = environment) do
    case Enum.reduce(environment.tools, {:ok, environment}, fn
           tool, {:ok, new_environment} -> install_tool(new_environment, tool)
           tool, {:error, new_environment} -> {:error, new_environment}
         end) do
      {:ok, new_environment} ->
        {:ok,
         %__MODULE__{
           confirm: environment.confirm,
           digest_file: environment.digest_file,
           tools_dir: environment.tools_dir,
           os: environment.os,
           state: "completed",
           started_at: environment.started_at,
           ended_at: DateTime.utc_now(),
           tools: environment.tools,
           operations: environment.operations
         }}

      {:error, environment} ->
        {:error, environment}
    end
  end

  @doc """
  Installs a tool and returns the updated environment

  ## Examples:

      # When tool is valid
      iex> options = [
      ...>   confirm: false,
      ...>   digest_file: ".temp.dump",
      ...>   tools_dir: "./test/support/tools/",
      ...>   os: "arch_linux"
      ...> ]
      iex> {:ok, tool} =
      ...>   Adify.YAML.parse_and_cast("./test/support/tools/valid/201907051629/tool.yaml")
      iex> tools = [tool]
      iex> {:ok, env} = Adify.Environment.init(options)
      iex> true = env.state == "new" && Enum.empty?(env.operations)
      iex> {:ok, env} = Adify.Environment.install_tool(env, tool)
      iex> env.state == "processing" && !Enum.empty?(env.operations)
      true
  """
  @spec install_tool(__MODULE__.t(), Adify.Tool.t()) ::
          {:ok, term()} | {:error, term()}
  def install_tool(%__MODULE__{} = environment, %Adify.Tool{} = tool) do
    operation = %Adify.Environment.Operation{
      state: "new",
      os: environment.os,
      tool: tool
    }

    case Adify.Environment.Operation.run(operation, environment.confirm) do
      {:ok, operation} ->
        {:ok,
         %__MODULE__{
           confirm: environment.confirm,
           digest_file: environment.digest_file,
           tools_dir: environment.tools_dir,
           os: environment.os,
           state: "processing",
           started_at: environment.started_at,
           tools: environment.tools,
           operations: (environment.operations || []) ++ [operation]
         }}

      {:error, operation} ->
        {:error,
         %__MODULE__{
           confirm: environment.confirm,
           digest_file: environment.digest_file,
           tools_dir: environment.tools_dir,
           os: environment.os,
           state: "failed",
           started_at: environment.started_at,
           ended_at: DateTime.utc_now(),
           tools: environment.tools,
           operations: (environment.operations || []) ++ [operation]
         }}
    end
  end

  @doc """
  Returns the digest file content when given an environment

  ## Examples:

      iex> options = [
      ...>   confirm: false,
      ...>   digest_file: ".temp.dump",
      ...>   tools_dir: "./test/support/tools/",
      ...>   os: "arch_linux"
      ...> ]
      iex> {:ok, tool} =
      ...>   Adify.YAML.parse_and_cast("./test/support/tools/valid/201907051629/tool.yaml")
      iex> tools = [tool]
      iex> {:ok, env} = Adify.Environment.init(options)
      iex> true = env.state == "new" && Enum.empty?(env.operations)
      iex> {:ok, env} = Adify.Environment.install_tools(env)
      iex> digest =Adify.Environment.digest_content(env)
      iex> digest =~ "Started at" && digest =~ "State: completed"
      true
  """
  @spec digest_content(__MODULE__.t()) :: String.t()
  def digest_content(environment) do
    """
    Started at: #{environment.started_at}
    State: #{environment.state}
    Ended at: #{environment.ended_at}

    Operations:
    #{environment.operations |> Enum.map(& &1.output) |> Enum.join("\n")}
    """
  end

  defp init_with_tools(opts, tools) do
    params = %{
      confirm: Keyword.get(opts, :confirm),
      digest_file: Keyword.get(opts, :digest_file),
      operations: [],
      os: Keyword.get(opts, :os),
      state: "new",
      started_at: DateTime.utc_now(),
      tools_dir: Keyword.get(opts, :tools_dir)
    }

    case changeset(%__MODULE__{tools: tools}, params) do
      changeset = %Ecto.Changeset{errors: []} ->
        {:ok, apply_changes(changeset)}

      %Ecto.Changeset{errors: errors} ->
        {:error, errors}
    end
  end

  # Tools dir should be of the format:
  # <tools_dir>/tool_name/tool_version/tool.yaml
  defp load_all_tools(tools_dir) do
    parse_results =
      tools_dir
      |> File.ls!()
      |> Enum.map(&Path.join(tools_dir, &1))
      |> Enum.map(&yaml_path/1)
      |> Enum.map(&Adify.YAML.parse_and_cast/1)

    errors =
      parse_results
      |> Enum.filter(&(elem(&1, 0) == :error))
      |> Enum.map(&elem(&1, 1))

    tools =
      parse_results
      |> Enum.filter(&(elem(&1, 0) == :ok))
      |> Enum.map(&elem(&1, 1))

    case Enum.empty?(errors) do
      false -> {:error, errors}
      true -> {:ok, tools}
    end
  end

  defp yaml_path(tool_name) do
    last_version =
      tool_name
      |> File.ls!()
      |> Enum.at(-1)

    Path.join([tool_name, last_version, "tool.yaml"])
  end
end

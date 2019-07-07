defmodule Adify.Tool.InstallationStrategy.Workflow do
  @moduledoc """
  Represents a list of `pre`, `post` and `main` command of a set of commands
  for an installation_strategy
  """

  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false

  embedded_schema do
    embeds_one(:pre, __MODULE__.Op)
    embeds_one(:main, __MODULE__.Op)
    embeds_one(:post, __MODULE__.Op)
  end

  def changeset(struct, params) do
    struct
    |> cast(params, [])
    |> cast_embed(:pre)
    |> cast_embed(:main, required: true)
    |> cast_embed(:post)
  end

  @spec run(__MODULE__.t()) :: {:ok, term()} | {:error, term()}
  def run(workflow) do
  end

  defmodule Op do
    @moduledoc """
    Representation around a command, expected output and success
    """

    use Ecto.Schema
    import Ecto.Changeset

    @primary_key false

    embedded_schema do
      field(:command, :string)
      field(:success, :boolean, default: true)
      field(:expected, :string, default: ".*")
    end

    def changeset(struct, params) do
      struct
      |> cast(params, [:command, :success, :expected])
      |> validate_required([:command])
    end

    @doc """
    Runs an operation

    ## Examples:

        # When success is true
        iex> operation = %Adify.Tool.InstallationStrategy.Workflow.Op{
        ...>   command: "echo hi",
        ...>   success: true,
        ...>   expected: ".*"
        ...> }
        iex> Adify.Tool.InstallationStrategy.Workflow.Op.run(operation)
        {:ok, "hi\\n"}

        # When success is true
        iex> operation = %Adify.Tool.InstallationStrategy.Workflow.Op{
        ...>   command: "echo hi",
        ...>   success: true,
        ...>   expected: "bad"
        ...> }
        iex> Adify.Tool.InstallationStrategy.Workflow.Op.run(operation)
        {:error, "Expression didn't match:\\nExpected: bad:\\nGot: hi\\n\\n"}

        # When regex is bad
        iex> operation = %Adify.Tool.InstallationStrategy.Workflow.Op{
        ...>   command: "echo hi",
        ...>   success: true,
        ...>   expected: "*"
        ...> }
        iex> Adify.Tool.InstallationStrategy.Workflow.Op.run(operation)
        {:error, {'nothing to repeat', 0}}

        # When success is false
        iex> operation = %Adify.Tool.InstallationStrategy.Workflow.Op{
        ...>   command: "echo hi",
        ...>   success: false,
        ...>   expected: ".*"
        ...> }
        iex> Adify.Tool.InstallationStrategy.Workflow.Op.run(operation)
        {:error, "hi\\n"}
    """
    @spec run(__MODULE__.t()) :: {:ok, term()} | {:error, term()}
    def run(operation) do
      case Adify.SystemInfo.cmd(operation.command) do
        {:error, output} ->
          case operation.success do
            false -> {:ok, output}
            true -> {:error, output}
          end
        {:ok, output} ->
          case operation.success do
            true -> check_regex(operation, output)
            false -> {:error, output}
          end
      end
    end

    defp check_regex(operation, output) do
      with {:ok, regex} <- Regex.compile(operation.expected),
           true <- (output =~ regex)
      do
        {:ok, output}
      else
        {:error, reason} -> {:error, reason}
        false ->
          {:error, """
            Expression didn't match:
            Expected: #{operation.expected}:
            Got: #{output}
            """}
      end
    end
  end
end

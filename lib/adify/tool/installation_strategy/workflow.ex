defmodule Adify.Tool.InstallationStrategy.Workflow do
  @moduledoc """
  Represents a list of `pre`, `post` and `main` command of a set of commands
  for an installation_strategy
  """

  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false

  @type t :: %__MODULE__{}

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

  @doc """
  Runs the workflow starting at `pre`, `main` and lastly `post`

  ## Examples

      # When pre, main and post are all success
      iex> pre = %Adify.Tool.InstallationStrategy.Workflow.Op{
      ...>   command: "echo hi",
      ...>   success: true,
      ...>   expected: ".*"
      ...> }
      iex> workflow = %Adify.Tool.InstallationStrategy.Workflow{
      ...>   pre: pre,
      ...>   main: pre,
      ...>   post: pre
      ...> }
      iex> Adify.Tool.InstallationStrategy.Workflow.run(workflow)
      {:ok, "Running Pre:\\nhi\\n\\nRunning Main:\\nhi\\n\\nRunning Post:\\nhi\\n\\n"}

      # When pre is a failure
      iex> pre = %Adify.Tool.InstallationStrategy.Workflow.Op{
      ...>   command: "echo hi",
      ...>   success: false,
      ...>   expected: ".*"
      ...> }
      iex> workflow = %Adify.Tool.InstallationStrategy.Workflow{
      ...>   pre: pre,
      ...>   main: pre,
      ...>   post: pre
      ...> }
      iex> Adify.Tool.InstallationStrategy.Workflow.run(workflow)
      {:error, "Running Pre:\\nhi\\n\\n"}

      # When main is a failure
      iex> pre = %Adify.Tool.InstallationStrategy.Workflow.Op{
      ...>   command: "echo hi",
      ...>   success: true,
      ...>   expected: ".*"
      ...> }
      iex> main = %Adify.Tool.InstallationStrategy.Workflow.Op{
      ...>   command: "echo hi",
      ...>   success: false,
      ...>   expected: ".*"
      ...> }
      iex> workflow = %Adify.Tool.InstallationStrategy.Workflow{
      ...>   pre: pre,
      ...>   main: main,
      ...>   post: pre
      ...> }
      iex> Adify.Tool.InstallationStrategy.Workflow.run(workflow)
      {:error, "Running Pre:\\nhi\\n\\nRunning Main:\\nhi\\n\\n"}

      # When post is a failure
      iex> pre = %Adify.Tool.InstallationStrategy.Workflow.Op{
      ...>   command: "echo hi",
      ...>   success: true,
      ...>   expected: ".*"
      ...> }
      iex> post = %Adify.Tool.InstallationStrategy.Workflow.Op{
      ...>   command: "echo hi",
      ...>   success: false,
      ...>   expected: ".*"
      ...> }
      iex> workflow = %Adify.Tool.InstallationStrategy.Workflow{
      ...>   pre: pre,
      ...>   main: pre,
      ...>   post: post
      ...> }
      iex> Adify.Tool.InstallationStrategy.Workflow.run(workflow)
      {:error, "Running Pre:\\nhi\\n\\nRunning Main:\\nhi\\n\\nRunning Post:\\nhi\\n\\n"}
  """
  @spec run(__MODULE__.t()) :: {:ok, term()} | {:error, term()}
  def run(workflow) do
    case __MODULE__.Op.run(workflow.pre) do
      {:error, pre_output} ->
        {:error,
         """
         Running Pre:
         #{pre_output}
         """}

      {:ok, pre_output} ->
        case __MODULE__.Op.run(workflow.main) do
          {:error, main_output} ->
            {:error,
             """
             Running Pre:
             #{pre_output}
             Running Main:
             #{main_output}
             """}

          {:ok, main_output} ->
            run_post(workflow, pre_output, main_output)
        end
    end
  end

  defp run_post(workflow, pre_output, main_output) do
    case __MODULE__.Op.run(workflow.post) do
      {:error, post_output} ->
        {:error,
         """
         Running Pre:
         #{pre_output}
         Running Main:
         #{main_output}
         Running Post:
         #{post_output}
         """}

      {:ok, post_output} ->
        {:ok,
         """
         Running Pre:
         #{pre_output}
         Running Main:
         #{main_output}
         Running Post:
         #{post_output}
         """}
    end
  end

  defmodule Op do
    @moduledoc """
    Representation around a command, expected output and success
    """

    use Ecto.Schema
    import Ecto.Changeset

    @primary_key false

    @type t :: %__MODULE__{}

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
    def run(nil), do: {:ok, ""}

    def run(operation) do
      IO.puts("""
      Running Op: #{operation.command}
      Expecting, success: #{operation.success}
      Expected output: #{operation.expected}
      """)

      case Adify.SystemInfo.cmd(operation.command) do
        {:error, output} ->
          IO.puts("""
          Ran op: #{operation.command}
          Output: #{output}
          """)

          case operation.success do
            false -> {:ok, output}
            true -> {:error, output}
          end

        {:ok, output} ->
          IO.puts("""
          Ran op: #{operation.command}
          Output: #{output}
          """)

          case operation.success do
            true -> check_regex(operation, output)
            false -> {:error, output}
          end
      end
    end

    defp check_regex(operation, output) do
      with {:ok, regex} <- Regex.compile(operation.expected),
           true <- output =~ regex do
        {:ok, output}
      else
        {:error, reason} ->
          {:error, reason}

        false ->
          {:error,
           """
           Expression didn't match:
           Expected: #{operation.expected}:
           Got: #{output}
           """}
      end
    end
  end
end

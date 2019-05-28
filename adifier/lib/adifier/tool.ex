defmodule Adifier.Tool do
  @moduledoc """
  Represents metadata related to a tool.

  Defines a `struct` with following variables:
  * `ran_at`: `Datetime`
  * `name` : `String`
  * `install_cmd`: `String`
  * `description` : `String`
  * `errors` : `String`

  Defines a `behaviour` with two `callbacks`:

  * `install_cmd/1`: This function returns the command used to install the
    tool on the `os` (given as the argument)
  * `description/0`: This function returns a the description of the `tool`.
  * `__name__/0`: This function returns the `name` of the `tool` being installed.
  """
  @enforce_keys ~w{ran_at name install_cmd description}a

  defstruct ~w{errors}a ++ @enforce_keys

  @type t :: %__MODULE__{
          ran_at: Datetime.t(),
          name: String.t(),
          install_cmd: String.t(),
          description: String.t()
        }

  @callback install_cmd(Atom.t()) :: {:ok | :error, __MODULE__.t()}
  @callback description() :: String.t()
  @callback __name__() :: String.t()

  @doc """
  This macro allows us to exploit the default behaviour of
  `Adifier.Tool` module.

  ## USAGE

  ```elixir
  defmodule Test.Tool do
    use Adifier.Tool, name: "tool"

    def description do
      "This tool runs `tool` tool"
    end
  end
  ```
  """
  defmacro __using__(opts \\ []) do
    name = Keyword.get(opts, :name, :default)

    quote location: :keep do
      import unquote(__MODULE__)
      alias Adifier.PackageManager, as: PacMan

      @behaviour unquote(__MODULE__)

      @impl true
      def install_cmd(os), do: PacMan.install_cmd(os, __name__())

      @impl true
      def __name__ do
        case unquote(name) do
          :default -> unquote(__MODULE__).__get_name__(__MODULE__)
          name -> name
        end
      end

      @impl true
      def description do
        raise """
        No description given for module: #{__MODULE__}.
        Please define the function #{__MODULE__}.description/0
        """
      end

      defoverridable install_cmd: 1, description: 0
    end
  end

  @doc false
  def __get_name__(module) do
    module
    |> Module.split()
    |> Enum.at(-1)
    |> String.downcase()
  end
end

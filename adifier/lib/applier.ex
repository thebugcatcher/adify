defmodule Adifier.Applier do
  @moduledoc """
  Behviour defined for an applier module
  """

  @callback run(atom, boolean) :: {:ok, :done} | {:error, term}

  defmacro __using__(_opts) do
    quote do
      @behaviour unquote(__MODULE__)

      @impl true
      def run(_, _), do: raise("run/2 isn't defined for #{__MODULE__}")

      defoverridable run: 2
    end
  end
end

defmodule Adifier.Tool do
  @moduledoc """
  """

  import Adifier.PackageManager

  @callback install_cmd(Atom.t()) :: {:ok, term} | {:error, String.t()}
  @callback description() :: String.t

  defmacro __using__(_opts) do
    quote do
      import Adifier.PackageManager

      def install_cmd(os) do
        raise "#{__MODULE__}.install_cmd/1 not implemented for os: #{os}"
      end

      # TODO: Move to module attribute
      def description() do
        raise """
        No description given for module: #{__MODULE__}..
        Please define the function #{__MODULE__}.description/0
        """
      end

      defoverridable [install: 1, description: 0]
    end
  end
end

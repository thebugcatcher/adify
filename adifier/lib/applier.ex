defmodule Adifier.Applier do
  @moduledoc """
  Behviour defined for an applier module
  """

  @callback run(os :: atom()) :: {:ok, term} | {:error, term}
end

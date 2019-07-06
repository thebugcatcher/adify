defmodule Adify.Environment.Operation do
  @moduledoc """
  Represents the data related to an environment operation. An environment
  operation is when a tool is attempted to be installed or uninstalled.
  """

  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false

  embedded_schema do
    field :confirmation, :boolean, default: false
    field :output, :string

    embeds_one :selected_installation_strategy, Adify.Tool.InstallationStrategy
    embeds_one :tool, Adify.Tool
  end

  def changeset(struct, params) do
    struct
    |> cast(params, [])
    |> cast_embed(:tool)
    |> cast_embed(:selected_installation_strategy)
  end
end

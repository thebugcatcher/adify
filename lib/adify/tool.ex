defmodule Adify.Tool do
  @moduledoc """
  Represents a Tool that can be installed/uninstalled using Adify
  """

  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false

  embedded_schema do
    field :name, :string
    field :version, :integer
    field :description, :string

    embeds_many :os_commands, Adify.Tool.OSCommand
  end

  def changeset(struct, params) do
    struct
    |> cast(params, [:name, :version, :description])
    |> validate_required([:name, :version, :description])
    |> cast_embed(:os_commands, required: true)
  end
end

defmodule Adify.Tool.InstallationStrategy do
  @moduledoc """
  Represents the set of commands with `up` and `down` with the priority
  """

  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false

  embedded_schema do
    field :name, :string
    field :number, :integer
    field :description, :string
    field :default, :boolean, default: false

    embeds_one :up, Adify.Tool.InstallationStrategy.Workflow
    embeds_one :down, Adify.Tool.InstallationStrategy.Workflow
  end

  def changeset(struct, params) do
    struct
    |> cast(params, [:name, :number, :description, :default])
    |> validate_required([:name, :number, :description])
    |> cast_embed(:up, required: true)
    |> cast_embed(:down, required: true)
  end
end

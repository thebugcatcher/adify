defmodule Adify.Tool.OSCommand do
  @moduledoc """
  Represents a set of commands that need to be run on an operating system.
  It follows similar patterns as Ecto and Rails migrations where it
  supports `up` and `down` to undo a tool installation
  """

  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false

  embedded_schema do
    field :os, :string

    embeds_many :installation_strategies, Adify.Tool.InstallationStrategy
  end

  def changeset(struct, params) do
    struct
    |> cast(params, [:os])
    |> validate_required([:os])
    |> cast_embed(:installation_strategies)
  end
end

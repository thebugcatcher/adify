defmodule Adify.Environment do
  @moduledoc """
  Represents the structure of an adification process. This represents the state
  of the system, intended state of the system and processes ran during
  adification.
  """

  use Ecto.Schema

  @primary_key false

  embedded_schema do
    field :os, :string
    field :confirm, :boolean
    field :digest_file, :string
    field :tools_dir, :string
    field :state, :string
    field :started_at, :utc_datetime
    field :ended_at, :utc_datetime
    field :meta, :map

    embeds_many :operations, Adify.Operation
    embeds_many :tools, Adify.Tool
  end
end

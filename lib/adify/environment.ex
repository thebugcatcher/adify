defmodule Adify.Environment do
  @moduledoc """
  Represents the structure of an adification process. This represents the state
  of the system, intended state of the system and processes ran during
  adification.
  """

  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false

  @valid_states ~w(new processing failed completed)

  embedded_schema do
    field :os, :string
    field :confirm, :boolean, default: true
    field :digest_file, :string
    field :tools_dir, :string
    field :state, :string, default: "new"
    field :started_at, :utc_datetime
    field :ended_at, :utc_datetime
    field :meta, :map, default: %{}

    embeds_many :operations, Adify.Environment.Operation
    embeds_many :tools, Adify.Tool
  end

  def changeset(struct, params) do
    struct
    |> cast(params, [:os, :confirm, :digest_file, :tools_dir, :state,
      :started_at, :ended_at, :meta])
    |> validate_required([:os, :digest_file, :tools_dir, :started_at])
    |> validate_inclusion(:state, @valid_states)
    |> cast_embed(:tools)
    |> cast_embed(:operations)
  end

  def init(opts \\ []) do
    params = %{
      confirm: Keyword.get(opts, :confirm),
      digest_file: Keyword.get(opts, :digest_file),
      os: "osx",
      state: "new",
      tools_dir: Keyword.get(opts, :tools_dir)
    }

    %__MODULE__{}
  end
end

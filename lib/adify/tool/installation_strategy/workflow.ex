defmodule Adify.Tool.InstallationStrategy.Workflow do
  @moduledoc """
  Represents a list of `pre`, `post` and `main` command of a set of commands
  for an installation_strategy
  """

  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false

  embedded_schema do
    embeds_one :pre, __MODULE__.Op
    embeds_one :main, __MODULE__.Op
    embeds_one :post, __MODULE__.Op
  end

  def changeset(struct, params) do
    struct
    |> cast(params, [])
    |> cast_embed(:pre)
    |> cast_embed(:main, required: true)
    |> cast_embed(:post)
  end

  defmodule Op do
    @moduledoc """
    Representation around a command, expected output and success
    """

    use Ecto.Schema
    import Ecto.Changeset

    @primary_key false

    embedded_schema do
      field :command, :string
      field :success, :boolean, default: true
      field :expected, :string, default: "*"
    end

    def changeset(struct, params) do
      struct
      |> cast(params, [:command, :success, :expected])
      |> validate_required([:command])
    end
  end
end

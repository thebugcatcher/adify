defmodule Adify.YAML do
  @moduledoc """
  API to do all YAML operations for Adify
  """

  @doc """
  Parses a YAML file for a tool and casts it to a struct, running all the
  ecto validations

  ## Examples:

      # When the YAML file is a valid file:
      iex> path =
      ...>   File.cwd!()
      ...>   |> Path.join("test/support/tools/valid/201907051629/tool.yaml")
      iex> {:ok, %Adify.Tool{version: vsn}} = Adify.YAML.parse_and_cast(path)
      iex> vsn
      201907051629

      # When the YAML file is not valid
      iex> path =
      ...>   File.cwd!()
      ...>   |> Path.join("test/support/invalid.yaml")
      iex> {:errors, errors} = Adify.YAML.parse_and_cast(path)
      iex> errors
      [os_commands: {"can't be blank", [validation: :required]},
        version: {"is invalid", [type: :integer, validation: :cast]}]
  """
  @spec parse_and_cast(Path.t()) :: {:ok, Adify.Tool.t()} | {:error, term()}
  def parse_and_cast(tool_yaml_path) do
    with {:ok, map} <- YamlElixir.read_from_file(tool_yaml_path),
         params <- to_params(map),
         changeset = %Ecto.Changeset{errors: []} <- cast_params(params)
    do
      {:ok, Ecto.Changeset.apply_changes(changeset)}
    else
      {:error, reason} -> {:error, reason}
      %Ecto.Changeset{errors: errors} -> {:errors, errors}
    end
  end

  defp cast_params(params), do: Adify.Tool.changeset(%Adify.Tool{}, params)

  @doc """
  Recursively convert all string keys to atom keys in a map

  ## Examples:

      # When params is a map
      iex> Adify.YAML.to_params(%{"key" => "value"})
      %{key: "value"}

      # When params is a list
      iex> Adify.YAML.to_params([%{key: "value"}, %{"key" => "value"}])
      [%{key: "value"}, %{key: "value"}]

      # When params is something else
      iex> Adify.YAML.to_params(:something_else)
      :something_else
  """
  def to_params(%{} = map) do
    for {key, val} <- map, into: %{} do
      case is_binary(key) do
        true -> {String.to_atom(key), to_params(val)}
        false -> {key, to_params(val)}
      end
    end
  end
  def to_params(list) when is_list(list), do: Enum.map(list, &to_params/1)
  def to_params(val), do: val
end

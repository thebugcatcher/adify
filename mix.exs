defmodule Adify.MixProject do
  use Mix.Project

  @version "0.1.0"
  @elixir "~> 1.9"

  def project do
    [
      app: :adify,
      version: @version,
      elixir: @elixir,
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:ecto, "~> 3.1.0"},
      {:yaml_elixir, "~> 2.4.0"}
    ]
  end
end

defmodule AdifyRunner.MixProject do
  use Mix.Project

  @name "Adify Runer"
  @version "0.1.0"
  @description """
  Runs Adify
  """

  @elixir "~> 1.8"

  def project do
    [
      app: :adify_runner,
      deps: deps(),
      description: @description,
      elixir: @elixir,
      name: @name,
      start_permanent: Mix.env() == :prod,
      version: @version
    ]
  end

  def application do
    [
      extra_applications: [:logger, :adify]
    ]
  end

  defp deps do
    [
      {:adify, "~> 0.1.1"}
    ]
  end
end

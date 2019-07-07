defmodule Adify.MixProject do
  use Mix.Project

  @name "Adify"
  @version "0.1.0"
  @description """
  A configurable, extendable DevOps environment app. This app installs tools
  based on the given operating systems.
  """

  @elixir "~> 1.9"

  def project do
    [
      app: :adify,
      deps: deps(),
      description: @description,
      dialyzer: [
        ignore_warnings: ".dialyzer_ignore.exs"
      ],
      docs: [
        main: "docs/GetStarted.md",
        logo: "logo/logo.png",
        extras: [
          "docs/GetStarted.md",
          "docs/Usage.md",
          "docs/Extend.md"
        ]
      ],
      elixir: @elixir,
      name: @name,
      preferred_cli_env: [
        "coveralls.detail": :test,
        "coveralls.html": :test,
        "coveralls.post": :test,
        coveralls: :test
      ],
      start_permanent: Mix.env() == :prod,
      test_coverage: [tool: ExCoveralls],
      version: @version
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      # Detailed Benchmarking & Analytics
      {:benchee, "~> 1.0.1", only: ~w(dev test)a},
      # Static code analyzer
      {:credo, "~> 1.0.5", only: :dev, runtime: false},
      # Static type analysis
      {:dialyxir, "~> 0.5.1", only: :dev, runtime: false},
      # ORM
      {:ecto, "~> 3.1.0"},
      # Generate & Publish docs
      {:ex_doc, "~> 0.19.3", only: :dev, runtime: false},
      # Test coverage cop
      {:excoveralls, "~> 0.10.5", only: ~w(dev test)a, runtime: false},
      # Static documentation analyzer
      {:inch_ex, "~> 2.0.0", only: ~w(dev test docs)a, runtime: false},
      # Parse and Interpret Yaml using Elixir
      {:yaml_elixir, "~> 2.4.0"}
    ]
  end
end

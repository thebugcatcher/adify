defmodule Adify.MixProject do
  use Mix.Project

  @name "Adify"
  @version "0.2.0"
  @description """
  A configurable, extendable DevOps environment app. This app installs tools
  based on the given operating systems.
  """

  @elixir "~> 1.10"

  def project do
    [
      app: :adify,
      build_embedded: Mix.env() == :prod,
      deps: deps(),
      description: @description,
      dialyzer: [
        ignore_warnings: ".dialyzer_ignore.exs",
        plt_add_apps: [:mix]
      ],
      docs: docs(),
      elixir: @elixir,
      name: @name,
      package: package(),
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
      {:excoveralls, "~> 0.10.6", only: ~w(dev test)a, runtime: false},
      # Static documentation analyzer
      {:inch_ex, "~> 2.0.0", only: ~w(dev test docs)a, runtime: false},
      # Parse and Interpret Yaml using Elixir
      {:yaml_elixir, "~> 2.4.0"}
    ]
  end

  defp package do
    [
      name: "adify",
      maintainers: ["Adi Iyengar"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/aditya7iyengar/adify"}
    ]
  end

  defp docs do
    [
      main: "Adify",
      source_ref: "#{@version}",
      logo: "logo/logo.png",
      groups_for_modules: [
        # Adify
        Helpers: [
          Adify.SystemInfo,
          Adify.YAML
        ],
        "Environment Metadata": [
          Adify.Environment,
          Adify.Environment.Operation
        ],
        "Tool Metadata": [
          Adify.Tool,
          Adify.Tool.OSCommand,
          Adify.Tool.InstallationStrategy,
          Adify.Tool.Workflow
        ]
      ],
      extra_section: "GUIDES",
      extras: [
        "guides/basic/GetStarted.md",
        "guides/basic/Usage.md",
        "guides/advanced/Extend.md"
      ],
      groups_for_extras: [
        Basic: ~r/guides\/basic\/.?/,
        Advanced: ~r/guides\/advanced\/.?/
      ]
    ]
  end
end

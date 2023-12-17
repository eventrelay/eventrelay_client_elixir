defmodule EventRelay.MixProject do
  use Mix.Project

  @source_url "https://github.com/eventrelay/eventrelay_client_elixir"
  @version "0.1.0"

  def project do
    [
      app: :eventrelay_client,
      version: @version,
      elixir: "~> 1.13",
      package: package(),
      deps: deps(),
      docs: docs()
    ]
  end

  def package do
    [
      description: "An EventRelay client for Elixir",
      maintainers: ["Thomas Brewer"],
      contributors: ["Thomas Brewer"],
      licenses: ["MIT"],
      links: %{
        GitHub: @source_url
      }
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false},
      {:ex_check, "~> 0.14.0", only: [:dev], runtime: false},
      {:credo, ">= 0.0.0", only: [:dev], runtime: false},
      {:dialyxir, ">= 0.0.0", only: [:dev], runtime: false},
      {:doctor, ">= 0.0.0", only: [:dev], runtime: false},
      {:grpc, "~> 0.7.0"},
      {:protobuf, "~> 0.11"},
      {:jason, "~> 1.1"},
      {:mimic, "~> 1.7", only: :test},
      {:nimble_options, "~> 1.0"}
    ]
  end

  defp docs do
    [
      extras: [
        LICENSE: [title: "License"],
        "README.md": [title: "Readme"]
      ],
      main: "readme",
      source_url: @source_url,
      source_ref: "v#{@version}",
      api_reference: false,
      formatters: ["html"]
    ]
  end
end

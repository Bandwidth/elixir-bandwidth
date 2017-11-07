defmodule Bandwidth.Mixfile do
  use Mix.Project

  @version "1.2.2"

  def project do
    [ app: :bandwidth,
      version: @version,
      elixir: "~> 1.4",
      description: "An Elixir client library for the Bandwidth Application Platform",
      package: package(),
      test_coverage: [tool: ExCoveralls],
      deps: deps(),
      aliases: aliases()]
  end

  defp aliases do
    test = case System.get_env "TRAVIS" do
      "true" -> { :test, "coveralls.travis"}
      _      -> { :test, "coveralls"}
    end

    [ test ]
  end

  def application do
    [ applications: [ :logger, :httpoison ] ]
  end

  defp package do
    [ files: ["lib", "mix.exs", "README.md", "LICENSE.md"],
      contributors: ["Tyler Cross", "Ross Lonstein"],
      licenses: ["MIT"],
      links: %{
        GitHub: "https://github.com/rlonstein/elixir-bandwidth",
        Documentation: "http://hexdocs.pm/bandwidth/#{@version}/"
      }
    ]
  end

  defp deps do
    [ { :httpoison, "~> 0.13.0" },
      { :poison, "~> 3.1.0" },
      { :dialyze, "~> 0.2.1", only: [:dev, :test] },
      { :ex_spec, "~> 2.0", only: :test },
      { :ex_doc, "~> 0.18.1", only: :dev },
      { :earmark, "~> 1.2.3", only: :dev },
      { :meck, github: "eproxus/meck", tag: "0.8.8", only: :test },
      { :excoveralls, "~> 0.7.4", only: [:dev, :test]}]
  end
end

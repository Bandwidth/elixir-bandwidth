defmodule Bandwidth.Mixfile do
  use Mix.Project

  @version "1.2.1"

  def project do
    [ app: :bandwidth,
      version: @version,
      elixir: "~> 1.0",
      description: "An Elixir client library for the Bandwidth Application Platform",
      package: package,
      test_coverage: [tool: ExCoveralls],
      deps: deps,
      aliases: aliases]
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
      contributors: ["Tyler Cross"],
      licenses: ["MIT"],
      links: %{
        GitHub: "https://github.com/wtcross/elixir-bandwidth",
        Documentation: "http://hexdocs.pm/bandwidth/#{@version}/"
      }
    ]
  end

  defp deps do
    [ { :httpoison, "~> 0.7.0" },
      { :poison, "~> 1.4.0" },
      { :dialyze, "~> 0.1.4", only: [:dev, :test] },
      { :ex_spec, "~> 0.3.0", only: :test },
      { :ex_doc, "~> 0.7.3", only: :dev },
      { :earmark, "~> 0.1.8", only: :dev },
      { :meck, github: "eproxus/meck", tag: "0.8.3", only: :test },
      { :excoveralls, "~> 0.3.10", only: [:dev, :test]}]
  end
end

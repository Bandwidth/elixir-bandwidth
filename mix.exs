defmodule Bandwidth.Mixfile do
  use Mix.Project

  def project do
    [ app: :bandwidth,
      version: "1.0.0",
      elixir: "~> 1.0",
      description: "An Elixir client library for the Bandwidth Application Platform",
      package: package,
      test_coverage: [tool: Coverex.Task, coveralls: true],
      deps: deps ]
  end

  def application do
    [ applications: [ :logger, :httpoison ] ]
  end

  defp package do
    [ files: ["lib", "mix.exs", "README.md", "LICENSE.md"],
      contributors: ["Tyler Cross"],
      licenses: ["MIT"],
      links: %{ "GitHub": "https://github.com/wtcross/elixir-bandwidth" } ]
  end

  defp deps do
    [ { :httpoison, "~> 0.7.0" },
      { :poison, "~> 1.4.0" },
      { :dialyze, "~> 0.1.4", only: [:dev, :test] },
      { :ex_spec, "~> 0.3.0", only: :test },
      { :meck, github: "eproxus/meck", tag: "0.8.3", only: :test },
      { :coverex, github: "wtcross/coverex", branch: "bump-dependency-versions", only: :test}]
  end
end

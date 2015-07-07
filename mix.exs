defmodule Bandwidth.Mixfile do
  use Mix.Project

  def project do
    [ app: :bandwidth,
      version: "1.0.0",
      elixir: "~> 1.0",
      description: "An Elixir client library for the Bandwidth Application Platform",
      package: package,
      test_coverage: [tool: Coverex.Task],
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
    [ { :httpoison, "~> 0.7.0", override: true },
      { :poison, "~> 1.4.0", override: true },
      { :dialyze, "~> 0.1.4", only: [:dev, :test] },
      { :ex_spec, "~> 0.3.0", only: :test },
      { :meck, git: "git@github.com:eproxus/meck.git", tag: "0.8.3", only: :test },
      { :coverex, "~> 1.3.0", only: :test}]
  end
end

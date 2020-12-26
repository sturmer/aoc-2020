defmodule Aoc2020.MixProject do
  use Mix.Project

  def project do
    [
      app: :aoc2020,
      version: "0.1.0",
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:number, "~> 1.0.3"},
      {:matrix_reloaded, "~> 2.2"},
      {:matrex, "~> 0.6"}
    ]
  end
end

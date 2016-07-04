defmodule Qiniu.Mixfile do
  use Mix.Project

  @version "0.3.1"

  def project do
    [app: :qiniu,
     version: @version,
     elixir: "~> 1.2",
     deps: deps,
     test_coverage: [tool: ExCoveralls],
     preferred_cli_env: preferred_cli_env,

     # Hex
     description: description,
     package: package
    ]
  end

  def application do
    [applications: [:logger, :httpoison]]
  end

  defp deps do
    [{:poison, "~> 2.0"},
     {:httpoison, "~> 0.8.3"},
     {:ex_doc, "~> 0.11.5", only: :docs},
     {:excoveralls, "~> 0.5.4", only: :test},
     {:earmark, "~> 0.2.1", only: :docs},
     {:inch_ex, "~> 0.5.1", only: :docs},
     {:mock, "~> 0.1.3", only: :test}
    ]
  end

  defp description do
    "Qiniu Resource (Cloud) Storage SDK for Elixir"
  end

  defp package do
    [maintainers: ["Tony Han"],
     licenses: ["MIT"],
     links: %{"GitHub" => "https://github.com/tony612/qiniu"},
     files: ~w(mix.exs README.md CHANGELOG.md lib config)]
  end

  defp preferred_cli_env do
    ["coveralls": :test, "coveralls.travis": :test, "coveralls.html": :test]
  end

end

defmodule Libcalculatorfinance.Mixfile do
  use Mix.Project

  def project do
    [app: :libcalculatorfinance,
     version: "0.0.1",
     elixir: "~> 1.2",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     description: description,
     package: package,
     deps: deps]
  end

  defp description do
    """
    Elixir library that contains functions that help
    with financial calculations, related to trading
    and investing.
    """
  end

  defp package do
    [
    files: ["lib", "mix.exs", "README.adoc"],
    maintainers: ["Andy Nagels"],
    licenses: ["BSD 2.0"],
    links: %{"GitHub" => "https://github.com/rockwolf/elixir/tree/libcalculatorfinance-release",
             "Docs" => "http://hexdocs.pm/libcalculatorfinance/"}
    ]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [applications: [:logger]]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [{:ex_doc, "~> 0.11", only: :dev},
     {:earmark, "~> 0.1", only: :dev}]
  end
end

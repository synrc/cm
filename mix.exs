defmodule CM.Mixfile do
  use Mix.Project
  def application(), do: [mod: {CM, []}, extra_applications: [:logger]]
  def project() do
    [
      app: :cm,
      version: "0.7.7",
      description: "CM  CXC 138 31 Configuration Management",
      releases: [ca: [include_executables_for: [:unix], cookie: "SYNRC:CM"]],
      package: [
        name: :cm,
        files: ~w(config priv lib mix.exs LICENSE README.md),
        licenses: ["ISC"],
        maintainers: ["Namdak Tonpa"],
        links: %{"GitHub" => "https://github.com/synrc/ca"}
      ],
      compilers: Mix.compilers(),
      deps: [{:ex_doc, ">= 0.0.0", only: :dev, runtime: false}]
    ]
  end
end

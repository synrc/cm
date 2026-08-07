import Config

config :cm,
  logger: [
    {:handler, :default2, :logger_std_h,
     %{
       level: :info,
       id: :synrc,
       max_size: 2000,
       module: :logger_std_h,
       config: %{type: :file, file: ~c"cm.log"},
       formatter:
         {:logger_formatter, %{template: [:time, ~c" ", :pid, ~c" ", :module, ~c" ", :msg, ~c"\n"], single_line: true}}
     }}
  ]

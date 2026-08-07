defmodule CM do
  @moduledoc """
  The main CA module implements Elixir application functionality
  that runs TCP and HTTP connections under Erlang/OTP supervision.
  """
  use Application

  def port(app) do
    Application.fetch_env!(:cmdb, app)
  end

  def start(_type, _args) do
  end


end

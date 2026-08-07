defmodule CM do
  @moduledoc """
  The main CM module implements Configuration Management application functionality.
  """
  use Application

  def port(app) do
    Application.fetch_env!(:cmdb, app)
  end

  def start(_type, _args) do
  end


end

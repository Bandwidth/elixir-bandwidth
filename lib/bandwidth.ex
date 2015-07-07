defmodule Bandwidth do
  defmacro __using__(_) do
    quote do
      alias Bandwidth.Client

      alias Bandwidth.Resources.Account
      alias Bandwidth.Resources.Applications
      alias Bandwidth.Resources.AvailableNumbers
      alias Bandwidth.Resources.Bridges
      alias Bandwidth.Resources.Calls
      alias Bandwidth.Resources.Conferences
      alias Bandwidth.Resources.Messages
    end
  end

  @moduledoc File.read!("README.md")
end

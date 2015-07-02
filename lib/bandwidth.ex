defmodule Bandwidth do
  defmacro __using__(_) do
    quote do
      alias Bandwidth.Client
      alias Bandwidth.Resources.Messages
      alias Bandwidth.Resources.Calls
    end
  end

  @moduledoc File.read!("README.md")
end

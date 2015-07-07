defmodule Bandwidth.Resources.AvailableNumbers do
  import Bandwidth.Client

  defmodule Local do
    def search(client),       do: get_resource(client, [ "availableNumbers", "local" ])
    def order(client, order), do: post_resource(client, [ "availableNumbers", "local" ])
  end

  defmodule TollFree do
    def search(client),       do: get_resource(client, [ "availableNumbers", "tollFree" ])
    def order(client, order), do: post_resource(client, [ "availableNumbers", "tollFree" ])
  end
end

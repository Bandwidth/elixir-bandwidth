defmodule Bandwidth.Resources.AvailableNumbers do
  import Bandwidth.Client

  defmodule Local do
    def search(client, params), do: get_resource(client, [ "availableNumbers", "local" ], params)
    def order(client, order),   do: post_resource(client, [ "availableNumbers", "local" ])
  end

  defmodule TollFree do
    def search(client, params), do: get_resource(client, [ "availableNumbers", "tollFree" ], params)
    def order(client, order),   do: post_resource(client, [ "availableNumbers", "tollFree" ])
  end
end

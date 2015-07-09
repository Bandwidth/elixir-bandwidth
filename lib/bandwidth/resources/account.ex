defmodule Bandwidth.Resources.Account do
  import Bandwidth.Client

  def self(client),                 do: get_user_resource(client, [ "account" ])
  def transactions(client, params), do: get_user_resource(client, [ "account", "transactions" ], params)
end

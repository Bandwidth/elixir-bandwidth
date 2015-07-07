defmodule Bandwidth.Resources.Messages do
  import Bandwidth.Client

  def list(client),            do: get_user_resource(client, [ "messages" ])
  def create(client, message), do: post_user_resource(client, [ "messages" ], message)
  def find(client, id),        do: get_user_resource(client, [ "messages", id ])
end

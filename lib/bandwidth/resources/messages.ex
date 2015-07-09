defmodule Bandwidth.Resources.Messages do
  import Bandwidth.Client

  def list(client, params),    do: get_user_resource(client, [ "messages" ], params)
  def create(client, message), do: post_user_resource(client, [ "messages" ], message)
  def find(client, id),        do: get_user_resource(client, [ "messages", id ])
end

defmodule Bandwidth.Resources.Messages do
  import Bandwidth.Client

  def list(client), do: get(client, [ "messages" ])
  def create(client, message), do: post(client, [ "messages" ], message)
  def find(client, id), do: get(client, ["messages", id])
end

defmodule Bandwidth.Resources.Bridges do
  import Bandwidth.Client

  def list(client),               do: get_user_resource(client, [ "bridges" ])
  def create(client, bridge),     do: post_user_resource(client, [ "bridges" ], bridge)
  def find(client, id),           do: get_user_resource(client, [ "bridges", id ])
  def update(client, id, bridge), do: post_user_resource(client, [ "bridges", id ], bridge)

  defmodule Audio do
    def play(client, bridge_id, audio), do: post_user_resource(client, [ "bridges", bridge_id, "audio" ], audio)
  end

  defmodule Calls do
    def list(client, bridge_id, audio), do: get_user_resource(client, [ "bridges", bridge_id, "calls" ])
  end
end

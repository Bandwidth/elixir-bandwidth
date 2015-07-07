defmodule Bandwidth.Resources.Applications do
  import Bandwidth.Client

  def list(client),                    do: get_user_resource(client, [ "applications" ])
  def create(client, application),     do: post_user_resource(client, [ "applications" ], application)
  def find(client, id),                do: get_user_resource(client, [ "applications", id ])
  def update(client, id, application), do: post_user_resource(client, [ "applications", id ], application)
  def delete(client, id),              do: delete_user_resource(client, [ "applications", id ])
end

defmodule Bandwidth.Resources.Applications do
  @moduledoc """
  The Applications resource lets you define call and message handling applications.
  You write an application on your own servers and have Bandwidth API send events
  to it by configuring a callback URL.

  [Bandwidth Docs](http://ap.bandwidth.com/docs/rest-api/applications/)
  """

  import Bandwidth.Client

  @doc ~S"""
  Get a list of your applications.

  ## Example:

      case Bandwidth.Resources.Applications.list(client) do
        {:ok, {200, applications, _}} -> IO.inspect applications
        {:error, reason}              -> IO.puts "Error: #{reason}"
      end

  [Bandwidth Docs](http://ap.bandwidth.com/docs/rest-api/applications/#resourceGETv1usersuserIdapplications)
  """
  @spec list(Client.t, Client.params) :: Client.response
  def list(client, params \\ []) do
    get_user_resource(client, [ "applications" ], params)
  end

  @doc ~S"""
  Create an application.

  ## Example:

      application = %{ name: "my-awesome-app" }
      case Bandwidth.Resources.Applications.create(client) do
        {:ok, {201, _, _}} -> IO.puts "Application created"
        {:error, reason}   -> IO.puts "Error: #{reason}"
      end

  [Bandwidth Docs](http://ap.bandwidth.com/docs/rest-api/applications/#resourcePOSTv1usersuserIdapplications)
  """
  @spec create(Client.t, Map.t) :: Client.response
  def create(client, application) do
    post_user_resource(client, [ "applications" ], application)
  end

  @doc ~S"""
  Get information about an application.

  ## Example:

      case Bandwidth.Resources.Applications.find(client, "some-application-id") do
        {:ok, {200, application, _}} -> IO.inspect application
        {:ok, {404, _, _}}           -> IO.puts "Application not found"
        {:error, reason}             -> IO.puts "Error: #{reason}"
      end

  [Bandwidth Docs](http://ap.bandwidth.com/docs/rest-api/applications/#resourceGETv1usersuserIdapplicationsapplicationId)
  """
  @spec find(Client.t, binary) :: Client.response
  def find(client, id) do
    get_user_resource(client, [ "applications", id ])
  end

  @doc ~S"""
  Make changes to an application.

  ## Example:

      application = %{ incomingCallUrl: "https://foo.com/calls" }
      case Bandwidth.Resources.Applications.update(client, "some-application-id", application) do
        {:ok, {200, _, _}} -> IO.puts "Application updated"
        {:error, reason}   -> IO.puts "Error: #{reason}"
      end

  [Bandwidth Docs](http://ap.bandwidth.com/docs/rest-api/applications/#resourcePOSTv1usersuserIdapplicationsapplicationId)
  """
  @spec update(Client.t, binary, Map.t) :: Client.response
  def update(client, id, application) do
    post_user_resource(client, [ "applications", id ], application)
  end

  @doc ~S"""
  Delete an application.

  ## Example:

      case Bandwidth.Resources.Applications.delete(client, "some-application-id") do
        {:ok, {200, _, _}} -> IO.puts "Application deleted"
        {:error, reason}   -> IO.puts "Error: #{reason}"
      end

  [Bandwidth Docs](http://ap.bandwidth.com/docs/rest-api/applications/#resourceDELETEv1usersuserIdapplicationsapplicationId)
  """
  @spec delete(Client.t, binary) :: Client.response
  def delete(client, id) do
    delete_user_resource(client, [ "applications", id ])
  end
end

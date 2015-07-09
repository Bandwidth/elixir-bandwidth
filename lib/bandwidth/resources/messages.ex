defmodule Bandwidth.Resources.Messages do
  @moduledoc """
  The Messages resource lets you send SMS/MMS messages and view messages that were
  previously sent or received.

  [Bandwidth Docs](http://ap.bandwidth.com/docs/rest-api/messages/)
  """

  import Bandwidth.Client

  @doc ~S"""
  Get a list of previous messages.

  ## Example:

      # List all previously sent messages
      case Bandwidth.Resources.Messages.list(client) do
        {:ok, {200, messages, _}} -> IO.inspect messages
        {:error, reason}          -> IO.puts "Error: #{reason}"
      end

      # List messages sent by a specific number.
      case Bandwidth.Resources.Messages.list(client, from: "+12223334444") do
        {:ok, {200, messages, _}} -> IO.inspect messages
        {:error, reason}          -> IO.puts "Error: #{reason}"
      end

  [Bandwidth Docs](http://ap.bandwidth.com/docs/rest-api/messages/#resourceGETv1usersuserIdmessages)
  """
  @spec list(Client.t, Client.params) :: Client.response
  def list(client, params \\ []) do
    get_user_resource(client, [ "messages" ], params)
  end

  @doc ~S"""
  Send a message.

  ## Example:

      message = %{ from: "+12223334444", to: "+3335557777", text: "HEY!" }
      case Bandwidth.Resources.Messages.create(client, message) do
        {:ok, {201, _, _}} -> IO.puts "Message sent"
        {:error, reason}   -> IO.puts "Error: #{reason}"
      end

  [Bandwidth Docs](http://ap.bandwidth.com/docs/rest-api/messages/#resourcePOSTv1usersuserIdmessages)
  """
  @spec create(Client.t, Map.t) :: Client.response
  def create(client, message) do
    post_user_resource(client, [ "messages" ], message)
  end

  @doc ~S"""
  Get information about a message.

  ## Example:

      case Bandwidth.Resources.Messages.find(client, "some-message-id") do
        {:ok, {200, message, _}} -> IO.inspect message
        {:error, reason}         -> IO.puts "Error: #{reason}"
      end

  [Bandwidth Docs](http://ap.bandwidth.com/docs/rest-api/messages/#resourceGETv1usersuserIdmessagesmessageId)
  """
  @spec find(Client.t, binary) :: Client.response
  def find(client, id) do
    get_user_resource(client, [ "messages", id ])
  end
end

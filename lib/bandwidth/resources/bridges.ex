defmodule Bandwidth.Resources.Bridges do
  @moduledoc """
  The Bridges resource allows you to bridge two calls together allowing for two way
  audio between them. A common example is bridging an incoming phone call together
  with a outgoing phone call.

  [Bandwidth Docs](http://ap.bandwidth.com/docs/rest-api/bridges/)
  """

  import Bandwidth.Client

  @doc ~S"""
  Get a list of previous bridges.

  ## Example:

      case Bandwidth.Resources.Bridges.list(client) do
        {:ok, {200, bridges, _}} -> IO.inspect bridges
        {:error, reason}         -> IO.puts "Error: #{reason}"
      end

  [Bandwidth Docs](http://ap.bandwidth.com/docs/rest-api/applications/#resourceGETv1usersuserIdapplications)
  """
  @spec list(Client.t) :: Client.response
  def list(client) do
    get_user_resource(client, [ "bridges" ])
  end

  @doc ~S"""
  Create a bridge.

  ## Example:

      case Bandwidth.Resources.Bridges.create(client) do
        {:ok, {201, _, _}} -> IO.puts "Bridge created"
        {:error, reason}   -> IO.puts "Error: #{reason}"
      end

  [Bandwidth Docs](http://ap.bandwidth.com/docs/rest-api/bridges/#resourcePOSTv1usersuserIdbridges)
  """
  @spec create(Client.t, Map.t) :: Client.response
  def create(client, bridge \\ %{}) do
    post_user_resource(client, [ "bridges" ], bridge)
  end

  @doc ~S"""
  Get information about an specific bridge.

  ## Example:

      case Bandwidth.Resources.Bridges.find(client, "some-bridge-id") do
        {:ok, {200, bridge, _}} -> IO.inspect bridge
        {:error, reason}        -> IO.puts "Error: #{reason}"
      end

  [Bandwidth Docs](http://ap.bandwidth.com/docs/rest-api/bridges/#resourceGETv1usersuserIdbridgesbridgeId)
  """
  @spec find(Client.t, binary) :: Client.response
  def find(client, id) do
    get_user_resource(client, [ "bridges", id ])
  end

  @doc ~S"""
  Add one or two calls in a bridge and also put the bridge on hold/unhold.

  ## Example:

      # Add call-id-1 and call-id-2 to the bridge
      bridge = %{ bridgeAudio: true, callIds: [ "call-id-1", "call-id-2" ] }
      case Bandwidth.Resources.Bridges.update(client, "some-bridge-id", bridge) do
        {:ok, {200, _, _}} -> IO.puts "Bridge updated"
        {:error, reason}   -> IO.puts "Error: #{reason}"
      end

  [Bandwidth Docs](http://ap.bandwidth.com/docs/rest-api/bridges/#resourcePOSTv1usersuserIdbridgesbridgeId)
  """
  @spec update(Client.t, binary, Map.t) :: Client.response
  def update(client, id, bridge) do
    post_user_resource(client, [ "bridges", id ], bridge)
  end

  defmodule Audio do
    @moduledoc """
    Perform audio-related actions for a specific bridge.
    """

    @doc ~S"""
    Play an audio file or speak a sentence in a bridge.

    ## Example:

        audio = %{ sentence: "Hello Bandwidth API user" }
        case Bandwidth.Resources.Bridges.Audio.play(client, "some-bridge-id", audio) do
          {:ok, {200, _, _}} -> IO.puts "Audio played"
          {:error, reason}   -> IO.puts "Error: #{reason}"
        end

    [Bandwidth Docs](http://ap.bandwidth.com/docs/rest-api/bridges/#resourcePOSTv1usersuserIdbridgesbridgeIdaudio)
    """
    @spec play(Client.t, binary, Map.t) :: Client.response
    def play(client, bridge_id, audio) do
      post_user_resource(client, [ "bridges", bridge_id, "audio" ], audio)
    end
  end

  defmodule Calls do
    @moduledoc """
    Manage calls associated with a bridge.
    """

    @doc ~S"""
    Get the list of calls that are on the bridge.

    ## Example:

        case Bandwidth.Resources.Bridges.Calls.list(client, "some-bridge-id") do
          {:ok, {200, calls, _}} -> IO.inspect calls
          {:error, reason}       -> IO.puts "Error: #{reason}"
        end

    [Bandwidth Docs](http://ap.bandwidth.com/docs/rest-api/bridges/#resourceGETv1usersuserIdbridgesbridgeIdcalls)
    """
    @spec list(Client.t, binary) :: Client.response
    def list(client, bridge_id) do
      get_user_resource(client, [ "bridges", bridge_id, "calls" ])
    end
  end
end

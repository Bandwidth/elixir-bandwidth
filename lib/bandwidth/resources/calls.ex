defmodule Bandwidth.Resources.Calls do
  @moduledoc """
  The Calls resource lets you make phone calls and view information about previous
  inbound and outbound calls.

  [Bandwidth Docs](http://ap.bandwidth.com/docs/rest-api/calls/)
  """

  import Bandwidth.Client

  @doc ~S"""
  Get a list of previous calls that were made or received.

  ## Example:

      case Bandwidth.Resources.Calls.list(client) do
        {:ok, {200, calls, _}} -> IO.inspect calls
        {:error, reason}       -> IO.puts "Error: #{reason}"
      end

  [Bandwidth Docs](http://ap.bandwidth.com/docs/rest-api/calls/#resourceGETv1usersuserIdcalls)
  """
  @spec list(Client.t, Client.params) :: Client.response
  def list(client, params \\ []) do
    get_user_resource(client, [ "calls" ], params)
  end

  @doc ~S"""
  Create an outbound phone call.

  ## Example:

      case Bandwidth.Resources.Calls.create(client, %{ to: "+12223334444", from: "+19199993333" }) do
        {:ok, {201, _, _}} -> IO.puts "Call created"
        {:error, reason}   -> IO.puts "Error: #{reason}"
      end

  [Bandwidth Docs](http://ap.bandwidth.com/docs/rest-api/calls/#resourcePOSTv1usersuserIdcalls)
  """
  @spec create(Client.t, Map.t) :: Client.response
  def create(client, call \\ %{}) do
    post_user_resource(client, [ "calls" ], call)
  end

  @doc ~S"""
  	Get information about a call that was made or received.

  ## Example:

      case Bandwidth.Resources.Calls.find(client, "some-call-id") do
        {:ok, {200, call, _}} -> IO.inspect call
        {:error, reason}      -> IO.puts "Error: #{reason}"
      end

  [Bandwidth Docs](http://ap.bandwidth.com/docs/rest-api/calls/#resourceGETv1usersuserIdcallscallId)
  """
  @spec find(Client.t, binary) :: Client.response
  def find(client, id) do
    get_user_resource(client, [ "calls", id ])
  end

  @doc ~S"""
  Manage an active phone call.

  ## Example:

      # Answer an incoming call
      case Bandwidth.Resources.Calls.update(client, "some-call-id", %{ state: "active" }) do
        {:ok, {200, _, _}} -> IO.puts "Call answered"
        {:error, reason}   -> IO.puts "Error: #{reason}"
      end

  [Bandwidth Docs](http://ap.bandwidth.com/docs/rest-api/calls/#resourcePOSTv1usersuserIdcallscallId)
  """
  @spec update(Client.t, binary, Map.t) :: Client.response
  def update(client, id, call) do
    post_user_resource(client, [ "calls", id ], call)
  end

  defmodule Audio do
    @moduledoc """
    Perform audio-related actions for a specific call.
    """

    @doc ~S"""
    Play an audio file or speak a sentence in a phone call.

    ## Example:

        audio = %{ sentence: "Hello Bandwidth API user" }
        case Bandwidth.Resources.Calls.Audio.play(client, "some-call-id", audio) do
          {:ok, {200, _, _}} -> IO.puts "Audio played"
          {:error, reason}   -> IO.puts "Error: #{reason}"
        end

    [Bandwidth Docs](http://ap.bandwidth.com/docs/rest-api/calls/#resourcePOSTv1usersuserIdcallscallIdaudio)
    """
    @spec play(Client.t, binary, Map.t) :: Client.response
    def play(client, call_id, audio) do
      post_user_resource(client, [ "calls", call_id, "audio" ], audio)
    end
  end

  defmodule DTMF do
    @moduledoc """
    Perform DTMF-related actions for a specific call.
    """

    @doc ~S"""
    Send DTMF (phone keypad digit presses).

    ## Example:

        case Bandwidth.Resources.Calls.DTMF.send(client, "some-call-id", %{ dtmfOut: "1234" }) do
          {:ok, {200, _, _}} -> IO.puts "DTMF sent"
          {:error, reason}   -> IO.puts "Error: #{reason}"
        end

    [Bandwidth Docs](http://ap.bandwidth.com/docs/rest-api/calls/#resourcePOSTv1usersuserIdcallscallIddtmf)
    """
    @spec send(Client.t, binary, Map.t) :: Client.response
    def send(client, call_id, dtmf \\ %{}) do
      post_user_resource(client, [ "calls", call_id, "dtmf" ], dtmf)
    end

    defmodule Gather do
      @moduledoc """
      Manage or create a DTMF Gather.
      """

      @doc ~S"""
      Gather the DTMF digits pressed.

      Collects a series of DTMF digits from a phone call with an optional prompt.
      This request returns immediately. When gather finishes, an event with the
      results will be posted to the callback URL.

      ## Example:

          case Bandwidth.Resources.Calls.DTMF.Gather.create(client, "some-call-id", %{ dtmfOut: "1234" }) do
            {:ok, {201, _, _}} -> IO.puts "Gather created"
            {:error, reason}   -> IO.puts "Error: #{reason}"
          end

      [Bandwidth Docs](http://ap.bandwidth.com/docs/rest-api/calls/#resourcePOSTv1usersuserIdcallscallIdgather)
      """
      @spec create(Client.t, binary, Map.t) :: Client.response
      def create(client, call_id, gather) do
        post_user_resource(client, [ "calls", call_id, "gather" ], gather)
      end

      @doc ~S"""
      Get the gather DTMF parameters and results.

      ## Example:

          case Bandwidth.Resources.Calls.DTMF.Gather.results(client, "some-call-id", "some-gather-id") do
            {:ok, {200, gather, _}} -> IO.inspect gather
            {:error, reason}        -> IO.puts "Error: #{reason}"
          end

      [Bandwidth Docs](http://ap.bandwidth.com/docs/rest-api/calls/#resourceGETv1usersuserIdcallscallIdgathergatherId)
      """
      @spec results(Client.t, binary, binary) :: Client.response
      def results(client, call_id, gather_id) do
        get_user_resource(client, [ "calls", call_id, "gather", gather_id ])
      end

      @doc ~S"""
      Update the gather.

      The only update allowed is %{ state: "completed" } to stop the gather.

      ## Example:

          case Bandwidth.Resources.Calls.DTMF.Gather.update(client, "some-call-id", "some-gather-id", %{ state: "completed"}) do
            {:ok, {200, gather, _}} -> IO.puts "Gather updated"
            {:error, reason}        -> IO.puts "Error: #{reason}"
          end

      [Bandwidth Docs](http://ap.bandwidth.com/docs/rest-api/calls/#resourcePOSTv1usersuserIdcallscallIdgathergatherId)
      """
      @spec update(Client.t, binary, binary, Map.t) :: Client.response
      def update(client, call_id, gather_id, gather) do
        post_user_resource(client, [ "calls", call_id, "gather", gather_id ], gather)
      end
    end
  end

  defmodule Events do
    @moduledoc """
    Access events associated with a specific call.
    """

    @doc ~S"""
    Gets the list of call events for a call.

    ## Example:

        case Bandwidth.Resources.Calls.Events.list(client, "some-call-id") do
          {:ok, {200, events, _}} -> IO.inspect events
          {:error, reason}        -> IO.puts "Error: #{reason}"
        end

    [Bandwidth Docs](http://ap.bandwidth.com/docs/rest-api/calls/#resourceGETv1usersuserIdcallscallIdevents)
    """
    @spec list(Client.t, binary) :: Client.response
    def list(client, call_id) do
      get_user_resource(client, [ "calls", call_id, "events" ])
    end

    @doc ~S"""
    Gets information about one call event.

    ## Example:

        case Bandwidth.Resources.Calls.Events.find(client, "some-call-id", "some-event-id") do
          {:ok, {200, event, _}} -> IO.inspect event
          {:error, reason}       -> IO.puts "Error: #{reason}"
        end

    [Bandwidth Docs](http://ap.bandwidth.com/docs/rest-api/calls/#resourceGETv1usersuserIdcallscallIdeventscallEventId)
    """
    @spec find(Client.t, binary, binary) :: Client.response
    def find(client, call_id, event_id) do
      get_user_resource(client, [ "calls", call_id, "events", event_id ])
    end
  end

  defmodule Recordings do
    @moduledoc """
    Access recordings associated with a specific call.
    """

    @doc ~S"""
    Retrieve all recordings related to the call.

    ## Example:

        case Bandwidth.Resources.Calls.Recordings.list(client, "some-call-id") do
          {:ok, {200, recordings, _}} -> IO.inspect recordings
          {:error, reason}            -> IO.puts "Error: #{reason}"
        end

    [Bandwidth Docs](http://ap.bandwidth.com/docs/rest-api/calls/#resourceGETv1usersuserIdcallscallIdrecordings)
    """
    @spec list(Client.t, binary) :: Client.response
    def list(client, call_id) do
      get_user_resource(client, [ "calls", call_id, "recordings" ])
    end
  end

  defmodule Transcriptions do
    @moduledoc """
    Access transcriptions associated with a specific call.
    """

    @doc ~S"""
    Retrieve all transcriptions related to the call.

    ## Example:

        case Bandwidth.Resources.Calls.Transcriptions.list(client, "some-call-id") do
          {:ok, {200, transcriptions, _}} -> IO.inspect transcriptions
          {:error, reason}                -> IO.puts "Error: #{reason}"
        end

    [Bandwidth Docs](http://ap.bandwidth.com/docs/rest-api/calls/#resourceGETv1usersuserIdcallscallIdtranscriptions)
    """
    @spec list(Client.t, binary) :: Client.response
    def list(client, call_id) do
      get_user_resource(client, [ "calls", call_id, "transcriptions" ])
    end
  end
end

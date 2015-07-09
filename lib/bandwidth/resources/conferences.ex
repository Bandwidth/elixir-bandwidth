defmodule Bandwidth.Resources.Conferences do
  @moduledoc """
  The Conferences resource allows you create conferences, add members to it, play
  audio, speak text, mute/unmute members, hold/unhold members and other things
  related to conferencing. Once a conference is created there is no timeout associated
  with it, i.e., the conference will stay in created state until it is explicitly
  terminated. After the last member of a conference is removed from it, the conference
  will be set automatically as completed.

  [Bandwidth Docs](http://ap.bandwidth.com/docs/rest-api/conferences/)
  """

  import Bandwidth.Client

  @doc ~S"""
  	Create a new conference.

  ## Example:

      case Bandwidth.Resources.Conferences.create(client, %{ from: "+12229993333" }) do
        {:ok, {201, _, _}} -> IO.puts "Call created"
        {:error, reason}   -> IO.puts "Error: #{reason}"
      end

  [Bandwidth Docs](http://ap.bandwidth.com/docs/rest-api/conferences/#resourcePOSTv1usersuserIdconferences)
  """
  @spec create(Client.t, Map.t) :: Client.response
  def create(client, conference) do
    post_user_resource(client, [ "conferences" ], conference)
  end

  @doc ~S"""
  	Retrieve conference information.

  ## Example:

      case Bandwidth.Resources.Conferences.find(client, "some-conference-id") do
        {:ok, {200, conference, _}} -> IO.inspect conference
        {:error, reason}            -> IO.puts "Error: #{reason}"
      end

  [Bandwidth Docs](http://ap.bandwidth.com/docs/rest-api/conferences/#resourceGETv1usersuserIdconferencesconferenceId)
  """
  @spec find(Client.t, binary) :: Client.response
  def find(client, id) do
    get_user_resource(client, [ "conferences", id ])
  end

  @doc ~S"""
  	Update conference.

  ## Example:

      case Bandwidth.Resources.Conferences.update(client, "some-conference-id", conference) do
        {:ok, {200, _, _}} -> IO.puts "Conference updated"
        {:error, reason}   -> IO.puts "Error: #{reason}"
      end

  [Bandwidth Docs](http://ap.bandwidth.com/docs/rest-api/conferences/#resourcePOSTv1usersuserIdconferencesconferenceId)
  """
  @spec update(Client.t, binary, Map.t) :: Client.response
  def update(client, id, conference) do
    post_user_resource(client, [ "conferences", id ], conference)
  end

  defmodule Audio do
    @moduledoc """
    Perform audio-related actions for a conference.
    """

    @doc ~S"""
    Play an audio file or speak a sentence in a phone call.

    ## Example:

        audio = %{ sentence: "Hello Bandwidth API user" }
        case Bandwidth.Resources.Conferences.Audio.play(client, "some-conference-id", audio) do
          {:ok, {200, _, _}} -> IO.puts "Audio played"
          {:error, reason}   -> IO.puts "Error: #{reason}"
        end

    [Bandwidth Docs](http://ap.bandwidth.com/docs/rest-api/conferences/#resourcePOSTv1usersuserIdconferencesconferenceIdaudio)
    """
    @spec play(Client.t, binary, Map.t) :: Client.response
    def play(client, conference_id, audio) do
      post_user_resource(client, [ "conferences", conference_id, "audio" ], audio)
    end
  end

  defmodule Members do
    @moduledoc """
    Manage conference members.
    """

    @doc ~S"""
    Add members to a conference.

    ## Example:

        member = %{ callId: "some-call-id" }
        case Bandwidth.Resources.Conferences.Members.add(client, "some-conference-id", member) do
          {:ok, {201, _, _}} -> IO.puts "Member added"
          {:error, reason}   -> IO.puts "Error: #{reason}"
        end

    [Bandwidth Docs](http://ap.bandwidth.com/docs/rest-api/conferences/#resourcePOSTv1usersuserIdconferencesconferenceIdmembers)
    """
    @spec add(Client.t, binary, Map.t) :: Client.response
    def add(client, conference_id, member) do
      post_user_resource(client, [ "conferences", conference_id, "members" ], member)
    end

    @doc ~S"""
    List all members of a conference.

    ## Example:

        case Bandwidth.Resources.Conferences.Members.list(client, "some-conference-id") do
          {:ok, {200, members, _}} -> IO.inspect members
          {:error, reason}         -> IO.puts "Error: #{reason}"
        end

    [Bandwidth Docs](http://ap.bandwidth.com/docs/rest-api/conferences/#resourceGETv1usersuserIdconferencesconferenceIdmembers)
    """
    @spec list(Client.t, binary) :: Client.response
    def list(client, conference_id) do
      get_user_resource(client, [ "conferences", conference_id, "members" ])
    end

    @doc ~S"""
    Update a conference member (remove, mute, hold).

    ## Example:

        # Remove a member from a conference
        member = %{ state: "completed" }
        case Bandwidth.Resources.Conferences.Members.update(client, "some-conference-id", "some-member-id", member) do
          {:ok, {200, _, _}} -> IO.puts "Member removed"
          {:error, reason}   -> IO.puts "Error: #{reason}"
        end

    [Bandwidth Docs](http://ap.bandwidth.com/docs/rest-api/conferences/#resourcePOSTv1usersuserIdconferencesconferenceIdmembersmemberId)
    """
    @spec update(Client.t, binary, binary, Map.t) :: Client.response
    def update(client, conference_id, member_id, member) do
      post_user_resource(client, [ "conferences", conference_id, "members", member_id ], member)
    end

    @doc ~S"""
    Retrieve properties for a single conference member.

    ## Example:

        case Bandwidth.Resources.Conferences.Members.find(client, "some-conference-id", "some-member-id") do
          {:ok, {200, member, _}} -> IO.inspect member
          {:error, reason}        -> IO.puts "Error: #{reason}"
        end

    [Bandwidth Docs](http://ap.bandwidth.com/docs/rest-api/conferences/#resourceGETv1usersuserIdconferencesconferenceIdmembersmemberId)
    """
    @spec find(Client.t, binary, binary) :: Client.response
    def find(client, conference_id, member_id) do
      get_user_resource(client, [ "conferences", conference_id, "members", member_id ])
    end

    defmodule Audio do
      @moduledoc """
      Perform audio-related actions for a specific conference member.
      """

      @doc ~S"""
      Play audio/speak to only one conference member.

      ## Example:

          audio = %{ sentence: "Hello Bandwidth API user" }
          case Bandwidth.Resources.Conferences.Members.Audio.play(client, "some-conference-id", "some-member-id", audio) do
            {:ok, {200, _, _}} -> IO.puts "Audio played for member"
            {:error, reason}   -> IO.puts "Error: #{reason}"
          end

      [Bandwidth Docs](http://ap.bandwidth.com/docs/rest-api/conferences/#resourcePOSTv1usersuserIdconferencesconferenceIdmembersmemberIdaudio)
      """
      @spec play(Client.t, binary, binary, Map.t) :: Client.response
      def play(client, conference_id, member_id, audio) do
        post_user_resource(client, [ "conferences", conference_id, "members", member_id, "audio" ], audio)
      end
    end
  end
end

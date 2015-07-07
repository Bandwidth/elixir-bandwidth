defmodule Bandwidth.Resources.Conferences do
  import Bandwidth.Client

  def create(client, conference),     do: post_user_resource(client, [ "conferences" ], conference)
  def find(client, id),               do: get_user_resource(client, [ "conferences", id ])
  def update(client, id, conference), do: post_user_resource(client, [ "conferences", id ], conference)

  defmodule Audio do
    def play(client, conference_id, audio), do: post_user_resource(client, [ "conferences", conference_id, "audio" ], audio)
  end

  defmodule Members do
    def add(client, conference_id, member),               do: post_user_resource(client, [ "conferences", conference_id, "members" ], member)
    def list(client, conference_id),                      do: get_user_resource(client, [ "conferences", conference_id, "members" ])
    def update(client, conference_id, member_id, member), do: post_user_resource(client, [ "conferences", conference_id, "members", member_id ], member)
    def find(client, conference_id, member_id),           do: get_user_resource(client, [ "conferences", conference_id, "members", member_id ])

    defmodule Audio do
      def play(client, conference_id, member_id, audio), do: post_user_resource(client, [ "conferences", conference_id, "members", member_id, "audio" ], audio)
    end
  end
end

defmodule Bandwidth.Resources.Calls do
  import Bandwidth.Client

  def list(client),             do: get(client, ["calls"])
  def create(client, call),     do: post(client, ["calls"], call)
  def find(client, id),         do: get(client, ["calls", id])
  def update(client, id, call), do: post(client, [ "calls", id ], call)

  defmodule Audio do
    def play(client, call_id, audio), do: post(client, ["calls", call_id, "audio"], audio)
  end

  defmodule DTMF do
    def send(client, call_id, dtmf), do: post(client, ["calls", call_id, "dtmf"], dtmf)

    defmodule Gather do
      def create(client, call_id, gather),            do: post(client, ["calls", call_id, "gather"], gather)
      def results(client, call_id, gather_id),        do: get(client, ["calls", call_id, "gather", gather_id])
      def update(client, call_id, gather_id, gather), do: post(client, ["calls", call_id, "gather", gather_id], gather)
    end
  end

  defmodule Events do
    def list(client, call_id),           do: get(client, ["calls", call_id, "events"])
    def find(client, call_id, event_id), do: get(client, ["calls", call_id, "events", event_id])
  end

  defmodule Recordings do
    def list(client, call_id), do: get(client, ["calls", call_id, "recordings"])
  end

  defmodule Transcriptions do
    def list(client, call_id), do: get(client, ["calls", call_id, "transcriptions"])
  end
end

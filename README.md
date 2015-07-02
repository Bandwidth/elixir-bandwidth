elixir-bandwidth
================

> An Elixir client library for the Bandwidth Application Platform

**Note:** This library is basically useless at this time.

## Install
Add as a dependency:
```elixir
defp deps() do
  [{:bandwidth, "~> 0.2.0"}]
end
```
Fetch and compile:
```bash
mix do deps.get, deps.compile
```

Or install as archive:
```
git clone https://github.com/wtcross/elixir-bandwidth.git
cd elixir-bandwidth
mix install
```

## Usage
```elixir
use Bandwidth
# Create a client
client = Client.new("user-id", "api-token", "api-secret")

# Find a message
case Messages.find(client, "m-slkdfjskldjfklsjfdlk") do
  {:ok, %HTTPoison.Response{status_code: 200, body: body}} -> IO.inspect body
  {:ok, %HTTPoison.Response{status_code: 404}}             -> IO.puts "not found :("
  {:error, %HTTPoison.Error{reason: reason}}               -> IO.inspect reason
end
```

## Resources
All Bandwidth resources are represented by a module.

### Bandwidth.Resources.Messages
**list/1** - Get a list of previous messages

**create/2** - Send message

**find/2** - Get information about a message

### Bandwidth.Resources.Calls
**list/1** - Get a list of previous calls that were made or received

**create/2** - Create an outbound phone call

**find/2** - Get information about a call that was made or received

**update/3** - Manage an active phone call.

### Bandwidth.Resources.Calls.Audio
**play/3** - Play an audio or speak a sentence in a call

### Bandwidth.Resources.Calls.DTMF
**send/3** - Send DTMF

### Bandwidth.Resources.Calls.DTMF.Gather
**create/3** - Gather the DTMF digits pressed

**results/3** - Get the gather DTMF parameters and results

**update/4** - Update the gather

### Bandwidth.Resources.Calls.Events
**list/2** - Gets the list of call events for a call

**find/3** - Gets information about one call event

### Bandwidth.Resources.Calls.Recordings
**list/2** - Retrieve all recordings related to the call

### Bandwidth.Resources.Calls.Transcriptions
**list/2** - Retrieve all transcriptions related to the call

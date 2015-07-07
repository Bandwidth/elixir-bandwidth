elixir-bandwidth
================

> An Elixir client library for the Bandwidth Application Platform

## Install
Add as a dependency:
```elixir
defp deps() do
  [{:bandwidth, "~> 1.0.0"}]
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
  {:ok, {200, message, headers}} -> IO.inspect message
  {:ok, {404, _, _}}             -> IO.puts "not found :("
  {:error, reason}               -> IO.inspect reason
end
```

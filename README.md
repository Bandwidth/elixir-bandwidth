elixir-bandwidth
================

> An Elixir client library for the Bandwidth Application Platform

[![Build Status](https://travis-ci.org/wtcross/elixir-bandwidth.svg?branch=master)](https://travis-ci.org/wtcross/elixir-bandwidth)
[![Coverage Status](https://coveralls.io/repos/wtcross/elixir-bandwidth/badge.svg?branch=master&service=github)](https://coveralls.io/github/wtcross/elixir-bandwidth?branch=master)
[![Hex Version](https://img.shields.io/hexpm/v/bandwidth.svg?style=flat)](https://hex.pm/packages/bandwidth)

## Install
Add as a dependency:
```elixir
defp deps() do
  [{:bandwidth, "~> 1.2.1"}]
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

# Send a message
message = %{from: "+12223334444", to: "+13334445555", text: "hello bandwidth"}
case Messages.create(client, message) do
  {:ok, {201, _, headers}} -> IO.puts "message sent!"
  {:error, reason}         -> IO.inspect reason
end

# Search for a local number
case AvailableNumbers.Local.search(client, zip: 22303) do
  {:ok, {200, numbers, headers}} -> IO.inspect numbers
  {:error, reason}               -> IO.inspect reason
end
```

[Documentation](http://hexdocs.pm/bandwidth/1.2.1/)

defmodule Bandwidth.Client do
  use HTTPoison.Base

  alias __MODULE__, as: Client

  defstruct user_id: nil, api_token: nil, api_secret: nil, endpoint: "https://api.catapult.inetwork.com/v1"

  @type t :: %Client{user_id: binary, api_token: binary, api_secret: binary, endpoint: binary}

  @spec new(binary, binary, binary) :: t
  def new(user_id, api_token, api_secret) do
    %Client{user_id: user_id, api_token: api_token, api_secret: api_secret}
  end

  @spec resource_url(t, [binary]) :: binary
  def resource_url(%Client{user_id: user_id, endpoint: endpoint}, path) do
    Path.join([endpoint, "users", user_id, Path.join(path)])
  end

  @type header :: {binary, binary}
  @spec add_headers(t, [header]) :: [header]
  def add_headers(%Client{api_token: api_token, api_secret: api_secret}, headers) do
    credentials = "#{api_token}:#{api_secret}"
    [
      {"Accept", "application/json"},
      {"Content-Type", "application/json"},
      {"Authorization", "Basic #{:base64.encode(credentials)}"}
    ] ++ headers
  end

  @type request_method :: :get | :put | :post | :delete | :put | :patch | :head
  @spec _request(t, request_method, binary | [binary], binary, [Header.t]) :: {:ok, Response.t | AsyncResponse.t} | {:error, Error.t}
  def _request(client, method, path, body \\ "", headers \\ [])
  def _request(client, method, path, body, headers) when is_binary(path) do
    _request(client, method, [path], body, headers)
  end
  def _request(client, method, path, body, headers) when is_list(path) do
    request(method, resource_url(client, path), body, add_headers(client, headers))
  end

  @spec get(t, binary | [ binary ]) :: {:ok, Response.t | AsyncResponse.t} | {:error, Error.t}
  def get(client, path) do
    _request(client, :get, path)
  end

  @spec post(t, binary | [ binary ], binary) :: {:ok, Response.t | AsyncResponse.t} | {:error, Error.t}
  def post(client, path, body) do
    _request(client, :post, path, body)
  end

  def process_response_body(body) do
    case body do
      "" -> body
      _  -> Poison.decode!(body)
    end
  end

  def process_request_body(body) do
    case body do
      "" -> body
      _  -> Poison.encode!(body)
    end
  end
end

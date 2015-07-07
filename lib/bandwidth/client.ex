defmodule Bandwidth.Client do
  alias __MODULE__, as: Client

  defstruct user_id: nil, api_token: nil, api_secret: nil, endpoint: "https://api.catapult.inetwork.com/v1"

  @type t              :: %Client{user_id: binary, api_token: binary, api_secret: binary, endpoint: binary}
  @type response       :: {integer, any, [header]}
  @type result         :: {:ok, response} | {:error, binary}
  @type header         :: {binary, binary}
  @type path_segments  :: binary | [ binary ]
  @type request_method :: :get | :put | :post | :delete | :put | :patch | :head

  @spec new(binary, binary, binary) :: t
  def new(user_id, api_token, api_secret) do
    %Client{user_id: user_id, api_token: api_token, api_secret: api_secret}
  end

  @spec url(t, path_segments) :: binary
  def url(%Client{endpoint: endpoint}, path_segments) do
    path = List.flatten([ path_segments ])
    Path.join([endpoint, Path.join(Enum.map path, &to_string/1)])
  end

  @spec add_headers(t, [header]) :: [header]
  def add_headers(%Client{api_token: api_token, api_secret: api_secret}, headers) do
    credentials = "#{api_token}:#{api_secret}"
    [
      {"Accept", "application/json"},
      {"Content-Type", "application/json"},
      {"Authorization", "Basic #{:base64.encode(credentials)}"}
    ] ++ headers
  end

  @spec request(t, request_method, path_segments, binary, [header]) :: result
  def request(client, method, path_segments, body \\ "", headers \\ []) do
    case HTTPoison.request(method, url(client, path_segments), process_request_body(body), add_headers(client, headers)) do
      {:ok, response} -> {:ok, process_response(response)}
      {:error, error} -> {:error, error.reason}
    end
  end

  @spec get_resource(t, path_segments) :: result
  def get_resource(client, path_segments) do
    request(client, :get, path_segments)
  end

  @spec post_resource(t, path_segments, binary) :: result
  def post_resource(client, path_segments, body \\ "") do
    request(client, :post, path_segments, body)
  end

  @spec delete_resource(t, path_segments) :: result
  def delete_resource(client, path_segments) do
    request(client, :delete, path_segments)
  end

  @spec get_user_resource(t, path_segments) :: result
  def get_user_resource(client = %Client{user_id: user_id}, path_segments) do
    get_resource(client, ["users", user_id, path_segments])
  end

  @spec post_user_resource(t, path_segments, binary) :: result
  def post_user_resource(client = %Client{user_id: user_id}, path_segments, body \\ "") do
    post_resource(client, ["users", user_id, path_segments], body)
  end

  @spec delete_user_resource(t, path_segments) :: result
  def delete_user_resource(client = %Client{user_id: user_id}, path_segments) do
    delete_resource(client, ["users", user_id, path_segments])
  end

  @spec process_response(HTTPoison.Response.t) :: result
  def process_response(response) do
    headers = response.headers
    status_code = response.status_code
    body = response.body

    processed_body = case body do
      ""                     -> nil
      _ when is_binary(body) -> Poison.decode! body
      _                      -> nil
    end

    {status_code, processed_body, headers}
  end

  def process_request_body(body) do
    case body do
      ""  -> ""
      nil -> ""
      _   -> Poison.encode! body
    end
  end
end

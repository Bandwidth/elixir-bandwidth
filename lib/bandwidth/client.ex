defmodule Bandwidth.Client do
  alias __MODULE__, as: Client

  defstruct user_id: nil, api_token: nil, api_secret: nil, endpoint: "https://api.catapult.inetwork.com/v1"

  @type t              :: %Client{user_id: binary, api_token: binary, api_secret: binary, endpoint: binary}
  @type response       :: {integer, any, [header]}
  @type result         :: {:ok, response} | {:error, binary}
  @type body           :: any
  @type header         :: {binary, binary}
  @type path_segments  :: binary | [ binary ]
  @type params         :: [ Keyword.t ]
  @type request_method :: :get | :put | :post | :delete | :put | :patch | :head

  @spec new(binary, binary, binary) :: t
  def new(user_id, api_token, api_secret) do
    %Client{user_id: user_id, api_token: api_token, api_secret: api_secret}
  end

  @spec get_user_resource(t, path_segments, params) :: result
  def get_user_resource(client = %Client{user_id: user_id}, path_segments, params \\ []) do
    get_resource(client, ["users", user_id, path_segments], params)
  end

  @spec post_user_resource(t, path_segments, body) :: result
  def post_user_resource(client = %Client{user_id: user_id}, path_segments, body \\ nil) do
    post_resource(client, ["users", user_id, path_segments], body)
  end

  @spec delete_user_resource(t, path_segments) :: result
  def delete_user_resource(client = %Client{user_id: user_id}, path_segments) do
    delete_resource(client, ["users", user_id, path_segments])
  end

  @spec get_resource(t, path_segments, params) :: result
  def get_resource(client, path_segments, params \\ []) do
    get(client, path_segments, params)
  end

  @spec post_resource(t, path_segments, body) :: result
  def post_resource(client, path_segments, body \\ nil) do
    post(client, path_segments, body)
  end

  @spec delete_resource(t, path_segments) :: result
  def delete_resource(client, path_segments) do
    delete(client, path_segments)
  end

  @spec get(t, path_segments, params) :: result
  defp get(client, path_segments, params \\ []) do
    url = url(client, path_segments)
    url = <<url :: binary, build_qs(params) :: binary>>
    request(client, :get, url)
  end

  @spec post(t, path_segments, body) :: result
  defp post(client, path_segments, body) do
    request(client, :post, url(client, path_segments), body)
  end

  @spec delete(t, path_segments) :: result
  defp delete(client, path_segments) do
    request(client, :delete, url(client, path_segments))
  end

  @spec request(t, request_method, binary, body, [header]) :: result
  defp request(client, method, url, body \\ nil, headers \\ []) do
    case HTTPoison.request(method, url, process_request_body(body), add_headers(client, headers)) do
      {:ok, response} -> {:ok, process_response(response)}
      {:error, error} -> {:error, error.reason}
    end
  end

  @spec url(t, path_segments) :: binary
  defp url(%Client{endpoint: endpoint}, path_segments) do
    path = List.flatten([ path_segments ])
    Path.join([endpoint, Path.join(Enum.map path, &to_string/1)])
  end

  @spec build_qs([{atom, binary}]) :: binary
  defp build_qs([]),  do: ""
  defp build_qs(kvs), do: to_string('?' ++ URI.encode_query(kvs))

  @spec add_headers(t, [header]) :: [header]
  defp add_headers(%Client{api_token: api_token, api_secret: api_secret}, headers) do
    credentials = "#{api_token}:#{api_secret}"
    [
      {"Accept", "application/json"},
      {"Content-Type", "application/json"},
      {"Authorization", "Basic #{:base64.encode(credentials)}"}
    ] ++ headers
  end

  @spec process_response(HTTPoison.Response.t) :: result
  defp process_response(%HTTPoison.Response{status_code: status_code, body: "", headers: headers}) do
    {status_code, nil, headers}
  end
  defp process_response(%HTTPoison.Response{status_code: status_code, body: nil, headers: headers}) do
    {status_code, nil, headers}
  end
  defp process_response(%HTTPoison.Response{status_code: status_code, body: body, headers: headers}) when is_binary(body) do
    body = case Poison.decode body do
      {:ok, data} -> data
      {:error, _} -> nil
    end

    {status_code, body, headers}
  end

  @spec process_response(body) :: body
  defp process_request_body(""),  do: ""
  defp process_request_body(nil), do: ""
  defp process_request_body(body), do: Poison.encode! body
end

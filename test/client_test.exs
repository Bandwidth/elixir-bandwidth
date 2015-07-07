defmodule Bandwidth.ClientTest do
  use ExSpec, async: true

  import Bandwidth.Client

  doctest Bandwidth

  @test_user_id "test-user-id"
  @test_api_token "test-auth-token"
  @test_api_secret "test-auth-secret"
  @default_endpoint "https://test-endpoint.com"

  setup_all do
    :meck.new :hackney, [:no_link]
    on_exit fn ->
      :meck.unload :hackney
    end
    :ok
  end

  def create_client(params \\ []) do
    defaults = [user_id: @test_user_id, api_token: @test_api_token, api_secret: @test_api_secret, endpoint: @default_endpoint]
    struct(Bandwidth.Client, Keyword.merge(defaults, params))
  end

  describe "creating a client struct" do
    context "with all required parameters" do
      setup_all do
        {:ok, client: new(@test_user_id, @test_api_token, @test_api_secret)}
      end

      it "creates the client", context do
        assert context[:client] == create_client(endpoint: "https://api.catapult.inetwork.com/v1")
      end

      describe "the created client" do
        it "has the correct default endpoint", context do
          assert context[:client].endpoint === "https://api.catapult.inetwork.com/v1"
        end
      end
    end
  end

  describe "getting a resource url" do
    context "when the client endpoint has a trailing slash" do
      it "returns the correct url" do
        client = create_client(endpoint: "http://test.com/")
        path = [ "items", 45 ]
        url = url(client, path)
        assert url === "#{client.endpoint}items/45"
      end
    end

    context "when the client endpoint does not have a trailing slash" do
      it "returns the correct url" do
        client = create_client(endpoint: "http://test.com")
        path = [ "items", 45 ]
        url = url(client, path)
        assert url === "#{client.endpoint}/items/45"
      end
    end

    context "when the path has non-string items" do
      it "returns the correct url" do
        client = create_client
        path = [ "items", 45 ]
        url = url(client, path)
        assert url === "#{client.endpoint}/items/45"
      end
    end

    context "when the path has all string items" do
      it "returns the correct url" do
        client = create_client
        path = [ "items", "foo" ]
        url = url(client, path)
        assert url === "#{client.endpoint}/items/foo"
      end
    end
  end

  describe "adding headers" do
    setup_all do
      {:ok, headers: add_headers(create_client, [])}
    end

    it "adds an accept header for json", context do
      assert Enum.any?(context[:headers], &(&1 === {"Accept", "application/json"}))
    end

    it "adds a content type header for json", context do
      assert Enum.any?(context[:headers], &(&1 === {"Content-Type", "application/json"}))
    end

    it "adds an authorization header", context do
      credentials = "#{@test_api_token}:#{@test_api_secret}"
      assert Enum.any?(context[:headers], &(&1 === {"Authorization", "Basic #{:base64.encode(credentials)}"}))
    end
  end

  describe "processing a request body" do
    context "with valid json" do
      it "returns the encoded body" do
        assert process_request_body(%{test: "data"}) === "{\"test\":\"data\"}"
      end
    end

    context "with invalid json" do
      it "returns the body as is" do
        assert process_request_body("4") === "\"4\""
      end
    end

    context "that is empty or nil" do
      it "returns nil" do
        assert process_request_body("")  === ""
        assert process_request_body(nil) === ""
      end
    end
  end

  describe "processing a response" do
    context "for a failed request" do
      context "with a body" do
        it "parses the body" do
          assert process_response(%HTTPoison.Response{status_code: 404, body: "{\"test\": 4}"}) === {404, %{"test" => 4}, []}
        end
      end

      context "without a body" do
        it "doesn't parse the body" do
          assert process_response(%HTTPoison.Response{status_code: 404})           === {404, nil, []}
          assert process_response(%HTTPoison.Response{status_code: 404, body: ""}) === {404, nil, []}
        end
      end
    end

    context "for a successful request" do
      context "with a body" do
        it "parses the body" do
          assert process_response(%HTTPoison.Response{status_code: 200, body: "{\"test\": 4}"}) === {200, %{"test" => 4}, []}
        end
      end

      context "without a body" do
        it "doesn't parse the body" do
        assert process_response(%HTTPoison.Response{status_code: 200})             === {200, nil, []}
          assert process_response(%HTTPoison.Response{status_code: 200, body: ""}) === {200, nil, []}
        end
      end
    end
  end

  describe "making a request" do
    setup_all do
      :meck.new HTTPoison, [:no_link]
      :meck.expect HTTPoison, :request, fn
        method, _, _, _ when method === :get    -> {:ok, %HTTPoison.Response{status_code: 200}}
        method, _, _, _ when method === :post   -> {:ok, %HTTPoison.Response{status_code: 200}}
        method, _, _, _ when method === :delete -> {:ok, %HTTPoison.Response{status_code: 200}}
      end
      on_exit fn ->
        :meck.unload HTTPoison
      end
      :ok
    end

    context "with the get helper" do
      it "uses the correct parameters" do
        assert get_resource(create_client, "test") === {:ok, {200, nil, []}}
      end
    end

    context "with the post helper" do
      it "uses the correct parameters" do
        assert post_resource(create_client, "test") === {:ok, {200, nil, []}}
      end
    end

    context "with the delete helper" do
      it "uses the correct parameters" do
        assert delete_resource(create_client, "test") === {:ok, {200, nil, []}}
      end
    end
  end
end

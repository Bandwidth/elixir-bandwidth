defmodule Bandwidth.ClientTest do
  use ExSpec, async: true

  import Bandwidth.Client

  @test_user_id "test-user-id"
  @test_api_token "test-auth-token"
  @test_api_secret "test-auth-secret"
  @default_endpoint "https://test-endpoint.com"
  @default_credentials "#{@test_api_token}:#{@test_api_secret}"
  @default_headers [
    {"Accept", "application/json"},
    {"Content-Type", "application/json"},
    {"Authorization", "Basic #{:base64.encode(@default_credentials)}"}
  ]

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
      setup do
        {:ok, client: new(@test_user_id, @test_api_token, @test_api_secret)}
      end

      it "creates the client", context do
        assert context[:client] == create_client(endpoint: "https://api.catapult.inetwork.com/v1")
      end

      it "the created client has the correct default endpoint", context do
        assert context[:client].endpoint === "https://api.catapult.inetwork.com/v1"
      end
    end
  end

  describe "making a request" do
    setup do
      :meck.new HTTPoison, [:no_link]
      on_exit fn ->
        :meck.unload HTTPoison
      end
      :ok
    end

    context "successfully" do
      it "returns an ok tuple" do
        args = [:get, "#{@default_endpoint}/users/#{@test_user_id}/test", "", @default_headers]
        :meck.expect HTTPoison, :request, [{args, {:ok, %HTTPoison.Response{status_code: 200}}}]
        assert get_user_resource(create_client, "test") === {:ok, {200, nil, []}}
        assert :meck.num_calls(HTTPoison, :request, args) === 1
        assert :meck.validate HTTPoison
        :meck.delete HTTPoison, :request, 4
      end
    end

    context "resulting in an error" do
      it "returns an error tuple" do
        reason = "some-error-happened"
        args = [:get, "#{@default_endpoint}/users/#{@test_user_id}/test", "", @default_headers]
        :meck.expect HTTPoison, :request, [{args, {:error, %HTTPoison.Error{reason: reason}}}]
        assert get_user_resource(create_client, "test") === {:error, reason}
        assert :meck.num_calls(HTTPoison, :request, args) === 1
        assert :meck.validate HTTPoison
        :meck.delete HTTPoison, :request, 4
      end
    end

    context "for a user resource" do
      context "with the get_user_resource helper" do
        it "sends the correct request" do
          args = [:get, "#{@default_endpoint}/users/#{@test_user_id}/test", "", @default_headers]
          :meck.expect HTTPoison, :request, [{args, {:ok, %HTTPoison.Response{status_code: 200}}}]
          assert get_user_resource(create_client, "test") === {:ok, {200, nil, []}}
          assert :meck.num_calls(HTTPoison, :request, args) === 1
          assert :meck.validate HTTPoison
          :meck.delete HTTPoison, :request, 4
        end
      end

      context "with the post_user_resource helper" do
        it "sends the correct request" do
          args = [:post, "#{@default_endpoint}/users/#{@test_user_id}/test", "{}", @default_headers]
          :meck.expect HTTPoison, :request, [{args, {:ok, %HTTPoison.Response{status_code: 200}}}]
          assert post_user_resource(create_client, "test", %{}) === {:ok, {200, nil, []}}
          assert :meck.num_calls(HTTPoison, :request, args) === 1
          assert :meck.validate HTTPoison
          :meck.delete HTTPoison, :request, 4
        end
      end

      context "with the delete_user_resource helper" do
        it "sends the correct request" do
          args = [:delete, "#{@default_endpoint}/users/#{@test_user_id}/test", "", @default_headers]
          :meck.expect HTTPoison, :request, [{args, {:ok, %HTTPoison.Response{status_code: 200}}}]
          assert delete_user_resource(create_client, "test") === {:ok, {200, nil, []}}
          assert :meck.num_calls(HTTPoison, :request, [:delete, "#{@default_endpoint}/users/#{@test_user_id}/test", "", @default_headers]) === 1
          assert :meck.validate HTTPoison
          :meck.delete HTTPoison, :request, 4
        end
      end
    end

    context "for a resource" do
      context "with the get_resource helper" do
        context "with query parameters" do
          it "sends the correct request" do
            args = [:get, "#{@default_endpoint}/test?one=1&two=2&three=3", "", @default_headers]
            :meck.expect HTTPoison, :request, [{args, {:ok, %HTTPoison.Response{status_code: 200}}}]
            assert get_resource(create_client, "test", one: 1, two: 2, three: 3) === {:ok, {200, nil, []}}
            assert :meck.num_calls(HTTPoison, :request, args) === 1
            assert :meck.validate HTTPoison
            :meck.delete HTTPoison, :request, 4
          end
        end

        context "without query parameters" do
          it "sends the correct request" do
            args = [:get, "#{@default_endpoint}/test", "", @default_headers]
            :meck.expect HTTPoison, :request, [{args, {:ok, %HTTPoison.Response{status_code: 200}}}]
            assert get_resource(create_client, "test") === {:ok, {200, nil, []}}
            assert :meck.num_calls(HTTPoison, :request, args) === 1
            assert :meck.validate HTTPoison
            :meck.delete HTTPoison, :request, 4
          end
        end
      end

      context "with the post_resource helper" do
        context "with no body" do
          it "sends the correct request" do
            args = [:post, "#{@default_endpoint}/test", "{}", @default_headers]
            :meck.expect HTTPoison, :request, [{args, {:ok, %HTTPoison.Response{status_code: 200}}}]
            assert post_resource(create_client, "test", %{}) === {:ok, {200, nil, []}}
            assert :meck.num_calls(HTTPoison, :request, args) === 1
            assert :meck.validate HTTPoison
            :meck.delete HTTPoison, :request, 4
          end
        end
      end

      context "with the delete_resource helper" do
        it "sends the correct request" do
          args = [:delete, "#{@default_endpoint}/test", "", @default_headers]
          :meck.expect HTTPoison, :request, [{args, {:ok, %HTTPoison.Response{status_code: 200}}}]
          assert delete_resource(create_client, "test") === {:ok, {200, nil, []}}
          assert :meck.num_calls(HTTPoison, :request, args) === 1
          assert :meck.validate HTTPoison
          :meck.delete HTTPoison, :request, 4
        end
      end
    end

    context "with a empty body response" do
      it "sets the result body to nil" do
        args = [:get, "#{@default_endpoint}/users/#{@test_user_id}/test", "", @default_headers]
        :meck.expect HTTPoison, :request, [{args, {:ok, %HTTPoison.Response{status_code: 200, body: ""}}}]
        assert get_user_resource(create_client, "test") === {:ok, {200, nil, []}}
        assert :meck.num_calls(HTTPoison, :request, args) === 1
        assert :meck.validate HTTPoison
        :meck.delete HTTPoison, :request, 4
      end
    end

    context "with a json response" do
      context "containing valid json" do
        it "decodes the json" do
          args = [:get, "#{@default_endpoint}/users/#{@test_user_id}/test", "", @default_headers]
          :meck.expect HTTPoison, :request, [{args, {:ok, %HTTPoison.Response{status_code: 200, body: "{\"foo\": \"bar\"}"}}}]
          assert get_user_resource(create_client, "test") === {:ok, {200, %{"foo" => "bar"}, []}}
          assert :meck.num_calls(HTTPoison, :request, args) === 1
          assert :meck.validate HTTPoison
          :meck.delete HTTPoison, :request, 4
        end
      end

      context "containing invalid json" do
        it "returns nil" do
          args = [:get, "#{@default_endpoint}/users/#{@test_user_id}/test", "", @default_headers]
          :meck.expect HTTPoison, :request, [{args, {:ok, %HTTPoison.Response{status_code: 200, body: "{\"f \"bar\"}"}}}]
          assert get_user_resource(create_client, "test") === {:ok, {200, nil, []}}
          assert :meck.num_calls(HTTPoison, :request, args) === 1
          assert :meck.validate HTTPoison
          :meck.delete HTTPoison, :request, 4
        end
      end
    end
  end
end

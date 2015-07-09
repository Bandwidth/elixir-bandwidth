defmodule Bandwidth.Resources.Domains do
  @moduledoc """
  A Domain resource represents a logical grouping of Endpoints resources.
  The name of the domain will be part of a public DNS record. For that reason,
  we let the customer choose their domain names. Once a domain has been created,
  endpoints can be created and managed within the context of the domain. Because
  endpoints can only exist within the context of a domain, creating a domain is
  the first step in creating endpoints.

  [Bandwidth Docs](http://ap.bandwidth.com/docs/rest-api/domains/)
  """

  import Bandwidth.Client

  @doc ~S"""
  Get a list of your domains.

  ## Example:

      case Bandwidth.Resources.Domains.list(client) do
        {:ok, {200, domains, _}} -> IO.inspect domains
        {:error, reason}         -> IO.puts "Error: #{reason}"
      end

  [Bandwidth Docs](http://ap.bandwidth.com/docs/rest-api/domains/#resourceGETv1usersuserIddomains)
  """
  @spec list(Client.t) :: Client.response
  def list(client) do
    get_user_resource(client, [ "domains" ])
  end

  @doc ~S"""
  Create a domain.

  ## Example:

      domain = %{
        name: "my-domain",
        description: "This is my domain"
      }
      case Bandwidth.Resources.Domains.create(client, domain) do
        {:ok, {201, _, _}} -> IO.puts "Domain created"
        {:error, reason}   -> IO.puts "Error: #{reason}"
      end

  [Bandwidth Docs](http://ap.bandwidth.com/docs/rest-api/domains/#resourcePOSTv1usersuserIddomains)
  """
  @spec create(Client.t, Map.t) :: Client.response
  def create(client, domain) do
    post_user_resource(client, [ "domains" ], domain)
  end

  @doc ~S"""
  Delete a domain.

  ## Example:

      case Bandwidth.Resources.Domains.delete(client, "some-domain-id") do
        {:ok, {200, _, _}} -> IO.puts "Domain deleted"
        {:error, reason}   -> IO.puts "Error: #{reason}"
      end

  [Bandwidth Docs](http://ap.bandwidth.com/docs/rest-api/domains/#resourceDELETEv1usersuseriddomainsdomainid)
  """
  @spec delete(Client.t, binary) :: Client.response
  def delete(client, id) do
    delete_user_resource(client, [ "domains", id ])
  end

  defmodule Endpoints do
    @moduledoc """
    An Endpoint resource represents an entity that can register with the Application
    Platform SIP Registrar and place and receive calls. This can be a device like
    a phone or a pad, or it can be a softphone on a computer.

    [Bandwidth Docs](http://ap.bandwidth.com/docs/rest-api/endpoints/)
    """

    @doc ~S"""
    Get a list of endpoints associated with a domain.

    ## Example:

        case Bandwidth.Resources.Domains.Endpoints.list(client, "some-domain-id") do
          {:ok, {200, endpoints, _}} -> IO.inspect endpoints
          {:error, reason}           -> IO.puts "Error: #{reason}"
        end

    [Bandwidth Docs](http://ap.bandwidth.com/docs/rest-api/endpoints/#resourceGETv1usersuseriddomainsdomainidendpoints)
    """
    @spec list(Client.t, binary) :: Client.response
    def list(client, domain_id) do
      get_user_resource(client, [ "domains", domain_id, "endpoints" ])
    end

    @doc ~S"""
    Create an endpoint associated with the specified domain.

    ## Example:

        endpoint = %{
          name: "test-device",
          description: "this is a test",
          domain_id: "some-domain-id",
          application_id: "some-application-id",
          enabled: true,
          credentials: {
            password: "some-password"
          }
        }
        case Bandwidth.Resources.Domains.Endpoints.create(client, "some-domain-id", endpoint) do
          {:ok, {201, _, _}} -> IO.puts "Endpoint created"
          {:error, reason}   -> IO.puts "Error: #{reason}"
        end

    [Bandwidth Docs](http://ap.bandwidth.com/docs/rest-api/endpoints/#resourcePOSTv1usersuseriddomainsdomainidendpoints)
    """
    @spec create(Client.t, binary, Map.t) :: Client.response
    def create(client, domain_id, endpoint) do
      post_user_resource(client, [ "domains", domain_id, "endpoints" ], endpoint)
    end

    @doc ~S"""
    Get information about a specific endpoint.

    ## Example:

        case Bandwidth.Resources.Domains.Endpoints.find(client, "some-domain-id", "some-endpoint-id") do
          {:ok, {200, endpoint, _}} -> IO.inspect endpoint
          {:error, reason}          -> IO.puts "Error: #{reason}"
        end

    [Bandwidth Docs](http://ap.bandwidth.com/docs/rest-api/endpoints/#resourceGETv1usersuseriddomainsdomainidendpointsendpointid)
    """
    @spec find(Client.t, binary, binary) :: Client.response
    def find(client, domain_id, endpoint_id) do
      get_user_resource(client, [ "domains", domain_id, "endpoints", endpoint_id ])
    end

    @doc ~S"""
    Delete a specific endpoint.

    ## Example:

        case Bandwidth.Resources.Domains.Endpoints.delete(client, "some-domain-id", "some-endpoint-id") do
          {:ok, {200, _, _}} -> IO.puts "Endpoint deleted"
          {:error, reason}   -> IO.puts "Error: #{reason}"
        end

    [Bandwidth Docs](http://ap.bandwidth.com/docs/rest-api/endpoints/#resourceDELETEv1usersuseriddomainsdomainidendpointsendpointid)
    """
    @spec delete(Client.t, binary, binary) :: Client.response
    def delete(client, domain_id, endpoint_id) do
      delete_user_resource(client, [ "domains", domain_id, "endpoints", endpoint_id ])
    end
  end
end

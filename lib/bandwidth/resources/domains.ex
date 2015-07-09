defmodule Bandwidth.Resources.Domains do
  @moduledoc """
  A domain is a way to logically group endpoints. The name of the domain will be
  part of a public DNS record. For that reason, we let the customer choose their
  domain names. Once a domain has been created, endpoints can be created and
  managed within the context of the domain. Because endpoints can only exist
  within the context of a domain, creating a domain is the first step in creating
  endpoints.

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
    get_user_resource(client, [ "domains" ], params)
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
end

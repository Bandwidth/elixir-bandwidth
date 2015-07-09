defmodule Bandwidth.Resources.AvailableNumbers do
  @moduledoc """
  The AvailableNumbers resource lets you search for numbers that are available for
  use with your application.

  [Bandwidth Docs](http://ap.bandwidth.com/docs/rest-api/available-numbers/)
  """

  import Bandwidth.Client

  defmodule Local do
    @moduledoc """
    Search and order local telephone numbers.
    """

    @doc ~S"""
    Search for available local numbers.

    ## Example:

        case Bandwidth.Resources.AvailableNumbers.Local.search(client, zip: 22303) do
          {:ok, {200, numbers, _}} -> IO.inspect numbers
          {:error, reason}         -> IO.puts "Error: #{reason}"
        end

    [Bandwidth Docs](http://ap.bandwidth.com/docs/rest-api/available-numbers/#resourceGETv1availableNumberslocal)
    """
    @spec search(Client.t, Client.params) :: Client.response
    def search(client, params \\ []) do
      get_resource(client, [ "availableNumbers", "local" ], params)
    end

    @doc ~S"""
    Search and order available local numbers.

    ## Example:

        order = %{ zip: 22303, quantity: 25 }
        case Bandwidth.Resources.AvailableNumbers.Local.order(client, order) do
          {:ok, {201, numbers, _}} -> IO.inspect numbers
          {:error, reason}         -> IO.puts "Error: #{reason}"
        end

    [Bandwidth Docs](http://ap.bandwidth.com/docs/rest-api/available-numbers/#resourcePOSTv1availableNumberslocal)
    """
    @spec order(Client.t, Map.t) :: Client.response
    def order(client, order) do
      post_resource(client, [ "availableNumbers", "local" ], order)
    end
  end

  defmodule TollFree do
    @moduledoc """
    Search and order toll free telephone numbers.
    """

    @doc ~S"""
    Search for available toll free numbers.

    ## Example:

        case Bandwidth.Resources.AvailableNumbers.TollFree.order(client, pattern: "*2?9*", quantity: 2) do
          {:ok, {200, numbers, _}} -> IO.inspect numbers
          {:error, reason}         -> IO.puts "Error: #{reason}"
        end

    [Bandwidth Docs](http://ap.bandwidth.com/docs/rest-api/available-numbers/#resourceGETv1availableNumberstollFree)
    """
    @spec search(Client.t, Client.params) :: Client.response
    def search(client, params \\ []) do
      get_resource(client, [ "availableNumbers", "tollFree" ], params)
    end

    @doc ~S"""
    Search and order available toll free numbers.

    ## Example:

        order = %{ quantity: 3 }
        case Bandwidth.Resources.AvailableNumbers.TollFree.order(client, order) do
          {:ok, {201, numbers, _}} -> IO.inspect numbers
          {:error, reason}         -> IO.puts "Error: #{reason}"
        end

    [Bandwidth Docs](http://ap.bandwidth.com/docs/rest-api/available-numbers/#resourcePOSTv1availableNumberstollFree)
    """
    @spec order(Client.t, Map.t) :: Client.response
    def order(client, order) do
      post_resource(client, [ "availableNumbers", "tollFree" ], order)
    end
  end
end

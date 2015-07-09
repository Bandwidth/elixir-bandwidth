defmodule Bandwidth.Resources.Account do
  @moduledoc """
  The Account resource allows you to retrieve your current balance, transaction list,
  account type and all elements related to your platform account.

  [Bandwidth Docs](http://ap.bandwidth.com/docs/rest-api/account/)
  """

  import Bandwidth.Client

  @doc ~S"""
  Get information about your account.

  ## Example:

      case Bandwidth.Resources.Account.self(client) do
        {:ok, {200, account, _}} -> IO.inspect account
        {:error, reason}         -> IO.puts "Error: #{reason}"
      end

  [Bandwidth Docs](http://ap.bandwidth.com/docs/rest-api/account/#resourceGETv1usersuserIdaccount)
  """
  @spec self(Client.t) :: Client.response
  def self(client) do
    get_user_resource(client, [ "account" ])
  end

  @doc ~S"""
  Get a list of the transactions made to your account.

  ## Example:

      case Bandwidth.Resources.Account.transactions(client, type: "charge") do
        {:ok, {200, transactions, _}} -> IO.inspect transactions
        {:error, reason}              -> IO.puts "Error: #{reason}"
      end

  [Bandwidth Docs](http://ap.bandwidth.com/docs/rest-api/account/#resourceGETv1usersuserIdaccounttransactions)
  """
  @spec transactions(Client.t, Client.params) :: Client.response
  def transactions(client, params \\ []) do
    get_user_resource(client, [ "account", "transactions" ], params)
  end
end

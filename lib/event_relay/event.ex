defmodule EventRelay.Event do
  @moduledoc """
  Helper functions for Events
  """
  require Logger

  def encode_data(%{data: data} = event) when is_binary(data) do
    event
  end

  def encode_data(%{data: data} = event) when is_map(data) do
    case Jason.encode(data) do
      {:ok, json} ->
        Map.put(event, :data, json)

      error ->
        Logger.error("EventRelay.Event.encode_data error=#{inspect(error)}")
        event
    end
  end

  def add_hmac(%{data: data} = event) when is_map(data) do
    encode_data(event) |> add_hmac()
  end

  def add_hmac(%{data: data} = event) when is_binary(data) do
    hmac =
      :crypto.mac(:hmac, :sha256, System.get_env("ER_CLIENT_HMAC_SECRET"), data)
      |> Base.encode16()
      |> String.downcase()

    context = Map.put(event.context, :eventrelay_hmac, hmac)

    Map.put(event, :context, context)
  end
end

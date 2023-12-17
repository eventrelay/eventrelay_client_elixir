defmodule EventRelay do
  @moduledoc """
  Documentation for `EventRelay`.
  """
  alias ERWeb.Grpc.Eventrelay.Events.Stub
  alias EventRelay.Context

  def channel(opts) do
    EventRelay.Channel.new(opts)
  end

  def call(func, context, topic, args) do
    apply(__MODULE__, func, [context, topic, args])
  end

  def publish_events(%Context{channel: channel} = _context, topic, events) do
    events =
      Enum.map(events, fn event ->
        event =
          case Jason.encode(event.data) do
            {:ok, json} ->
              Map.put(event, :data, json)

            error ->
              Logger.error("EventRelay.publish_events error=#{inspect(error)}")
              event
          end

        struct(ERWeb.Grpc.Eventrelay.NewEvent, event)
      end)

    request = %ERWeb.Grpc.Eventrelay.PublishEventsRequest{
      topic: topic,
      durable: true,
      events: events
    }

    Client.publish_events(channel, request)
  end

  def pull_queued_events(channel, subscription_id, batch_size) do
    request = %ERWeb.Grpc.Eventrelay.PullQueuedEventsRequest{
      subscription_id: subscription_id,
      batch_size: batch_size
    }

    Stub.pull_queued_events(channel, request)
  end
end
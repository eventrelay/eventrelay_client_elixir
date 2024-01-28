defmodule EventRelay do
  @moduledoc """
  Documentation for `EventRelay`.
  """
  require Logger
  alias ERWeb.Grpc.Eventrelay.Events.Stub
  alias EventRelay.Context
  alias EventRelay.Event

  @typedoc """
  A UUIDv4 for a destination 
  """
  @type destination_id() :: binary()

  @typedoc """
  A UUIDv4 for an event 
  """
  @type event_id() :: binary()

  @typedoc """
  A postive integer representing how many events you want to pull
  """
  @type batch_size() :: pos_integer()

  @typedoc """
  The name of the topic
  """
  @type topic_name() :: binary()

  def call(func, context, topic, args) do
    apply(__MODULE__, func, [context, topic, args])
  end

  @doc """
  Publish events
  """
  @spec publish_events(Context.t(), topic_name(), [map()]) :: term()
  def publish_events(%Context{channel: channel} = _context, topic, events) do
    events =
      Enum.map(events, fn event ->
        event = Event.encode_data(event)
        struct(ERWeb.Grpc.Eventrelay.NewEvent, event)
      end)

    request = %ERWeb.Grpc.Eventrelay.PublishEventsRequest{
      topic: topic,
      durable: true,
      events: events
    }

    Stub.publish_events(channel, request)
  end

  @doc """
  Pull queued events
  """
  @spec pull_queued_events(Context.t(), destination_id(), batch_size()) :: term()
  def pull_queued_events(%Context{channel: channel} = _context, destination_id, batch_size) do
    request = %ERWeb.Grpc.Eventrelay.PullQueuedEventsRequest{
      destination_id: destination_id,
      batch_size: batch_size
    }

    Stub.pull_queued_events(channel, request)
  end

  @doc """
  Unlocks queued events
  """
  @spec unlock_queued_events(Context.t(), destination_id(), [event_id()]) :: term()
  def unlock_queued_events(%Context{channel: channel} = _context, destination_id, event_ids)
      when is_list(event_ids) do
    request = %ERWeb.Grpc.Eventrelay.UnLockQueuedEventsRequest{
      destination_id: destination_id,
      event_ids: event_ids
    }

    Stub.un_lock_queued_events(channel, request)
  end
end

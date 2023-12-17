defmodule EventRelay.Audit do
  @moduledoc """
    Send audit logging events to EventRelay

  """

  alias EventRelay.Audit.Options
  alias EventRelay.Event

  @doc """
    Log an event to the audit log in EventRelay

    ## Options

    #{NimbleOptions.docs(EventRelay.Audit.Options.definition())}
  """
  def log(context, opts \\ []) do
    opts_with_default = NimbleOptions.validate!(opts, Options.definition())

    topic = opts_with_default[:topic]

    default_data = %{
      event: %{name: opts_with_default[:name], description: opts_with_default[:description]}
    }

    data = Map.merge(default_data, opts_with_default[:data])

    event =
      %{
        name: opts_with_default[:name],
        source: opts_with_default[:source],
        reference_key: opts_with_default[:reference_key],
        group_key: opts_with_default[:group_key],
        user_id: opts_with_default[:user_id],
        data: data,
        context: opts_with_default[:context],
        occurred_at: opts_with_default[:occurred_at]
      }
      |> Event.encode_data()
      |> Event.add_hmac()

    EventRelay.call(:publish_events, context, topic, [event])
  end
end

defmodule EventRelay.AuditTest do
  use ExUnit.Case
  use Mimic
  doctest EventRelay.Audit

  describe "log/2" do
    test "publishes an audit log event to EventRelay" do
      EventRelay
      |> expect(:call, 1, fn :publish_events, _context, topic, events ->
        event = List.first(events)

        assert Enum.count(events) == 1
        assert topic == "audit_log"
        assert event[:name] == "patient.updated"

        assert event[:data] == %{
                 event: %{name: "patient.updated", description: "Patient updated"}
               }

        assert event[:context] == %{}
        assert event[:reference_key] == "1"
        assert event[:group_key] == "1"
        assert event[:user_id] == "1"
        assert event[:source] == "EventRelay Client"
      end)

      context = %EventRelay.Context{}

      opts = [
        name: "patient.updated",
        description: "Patient updated",
        user_id: "1",
        reference_key: "1",
        group_key: "1",
        context: %{},
        data: %{}
      ]

      EventRelay.Audit.log(context, opts)
    end
  end
end

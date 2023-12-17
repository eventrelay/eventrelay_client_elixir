defmodule EventRelay.AuditTest do
  use ExUnit.Case
  use Mimic
  doctest EventRelay.Audit

  describe "log/2" do
    setup do
      System.put_env(
        "ER_CLIENT_HMAC_SECRET",
        "test"
      )

      on_exit(fn ->
        System.put_env("ER_CLIENT_HMAC_SECRET", "")
      end)
    end

    test "publishes an audit log event to EventRelay" do
      EventRelay
      |> expect(:call, 1, fn :publish_events, _context, topic, events ->
        event = List.first(events)

        assert Enum.count(events) == 1
        assert topic == "audit_log"
        assert event[:name] == "patient.updated"

        assert event[:data] ==
                 "{\"event\":{\"name\":\"patient.updated\",\"description\":\"Patient updated\"}}"

        # verify the correct hmac is calculated
        assert event[:context] == %{
                 eventrelay_hmac:
                   "b247451b8a675949eb912884d0d3119efc25b759d9d618590b4932f5502083a0"
               }

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

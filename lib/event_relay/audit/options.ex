defmodule EventRelay.Audit.Options do
  @moduledoc false

  definition = [
    topic: [
      type: {:custom, __MODULE__, :type_non_empty_string, [[{:name, :topic}]]},
      required: false,
      default: "audit_log",
      doc: """
      The name of the topic in EventRelay that you want to log your audit log events to. It
      defaults to `audit_log` so make sure that topic is setup in EventRelay or override
      it with a topic that is setup in EventRelay.
      """
    ],
    name: [
      type: {:custom, __MODULE__, :type_non_empty_string, [[{:name, :name}]]},
      required: true,
      doc: """
      A name for the event that triggered an entry in the audit log.
      """
    ],
    description: [
      type: {:custom, __MODULE__, :type_non_empty_string, [[{:name, :description}]]},
      required: true,
      doc: """
      A description of the event that triggered an entry in the audit log.
      """
    ],
    user_id: [
      type: {:custom, __MODULE__, :type_non_empty_string, [[{:name, :user_id}]]},
      required: true,
      doc: """
      This is the ID of the user or actor that triggered the event.
      """
    ],
    reference_key: [
      type: {:custom, __MODULE__, :type_non_empty_string, [[{:name, :reference_key}]]},
      required: true,
      doc: """
      This is the ID of the target object/resource that is being changed
      """
    ],
    group_key: [
      type: {:custom, __MODULE__, :type_non_empty_string, [[{:name, :group_key}]]},
      required: true,
      doc: """
      This is a value used to track the organization, tenant, team, account that this is related to.
      """
    ],
    data: [
      type: :map,
      required: false,
      doc: """
      This is any data that you want to store about the state of the system at the time 
      the event occurred.
      """
    ],
    context: [
      type: {:map, :string, :string},
      required: false,
      default: %{},
      doc: """
      In the context you can provide data like IP address, server ID, cloud region, etc.
      """
    ],
    source: [
      type: {:custom, __MODULE__, :type_non_empty_string, [[{:name, :source}]]},
      default: "EventRelay Client",
      doc: """
      The source of the event being sent to the audit log like application name.
      """
    ],
    occurred_at: [
      type: {:custom, __MODULE__, :type_non_empty_string, [[{:name, :occurred_at}]]},
      required: false,
      doc: """
      """
    ]
  ]

  @definition NimbleOptions.new!(definition)

  def definition do
    @definition
  end

  def type_non_empty_string("", [{:name, name}]) do
    {:error, "expected :#{name} to be a non-empty string, got: \"\""}
  end

  def type_non_empty_string(value, _)
      when not is_nil(value) and is_binary(value) do
    {:ok, value}
  end

  def type_non_empty_string(value, [{:name, name}]) do
    {:error, "expected :#{name} to be a non-empty string, got: #{inspect(value)}"}
  end
end

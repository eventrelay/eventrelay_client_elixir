defmodule EventRelay.Channel.Options do
  @moduledoc false

  definition = [
    host: [
      type: {:custom, __MODULE__, :type_non_empty_string, [[{:name, :host}]]},
      required: true,
      doc: """
      The hostname of your EventRelay servers
      """
    ],
    port: [
      type: {:custom, __MODULE__, :type_non_empty_string, [[{:name, :port}]]},
      required: true,
      doc: """
      The port that the EventRelay GRPC API is listening on.
      """
    ],
    token: [
      type: {:custom, __MODULE__, :type_non_empty_string, [[{:name, :token}]]},
      required: false,
      doc: """
      The API Key token 
      """
    ],
    cacertfile: [
      type: {:custom, __MODULE__, :type_non_empty_string, [[{:name, :cacertfile}]]},
      required: false,
      doc: """
      The CA's PEM encoded certificate
      """
    ],
    certfile: [
      type: {:custom, __MODULE__, :type_non_empty_string, [[{:name, :certfile}]]},
      required: false,
      doc: """
      The API Key TLS certificate
      """
    ],
    keyfile: [
      type: {:custom, __MODULE__, :type_non_empty_string, [[{:name, :keyfile}]]},
      required: false,
      doc: """
      The API Key TLS key
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

defmodule EventRelay.Channel do
  @moduledoc """
  Module to interact with EventRelay
  """

  @doc """
    Create an EventRelay Channel

    ## Options

    #{NimbleOptions.docs(EventRelay.Channel.Options.definition())}
  """
  def new(opts) do
    host = opts[:host]
    port = opts[:port]
    token = opts[:token]
    cacertfile = opts[:cacertfile]
    certfile = opts[:certfile]
    keyfile = opts[:keyfile]

    grpc_opts = []

    grpc_opts =
      if cacertfile && certfile && keyfile do
        cred =
          GRPC.Credential.new(
            ssl: [
              verify: :verify_peer,
              cacertfile: cacertfile,
              keyfile: keyfile,
              certfile: certfile
            ]
          )

        Keyword.merge(grpc_opts, cred: cred)
      else
        grpc_opts
      end

    grpc_opts =
      if token do
        Keyword.put(grpc_opts, :headers, [
          {"authorization", "Bearer #{token}"}
        ])
      else
        grpc_opts
      end

    GRPC.Stub.connect("#{host}:#{port}", grpc_opts)
  end
end

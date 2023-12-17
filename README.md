# EventRelay Client for Elixir

A package to make it easy to integrate with EventRelay in Elixir applications.

*WARNING: This is very alpha. Expect breaking changes.*

## Installation

If [available in Hex](https://hex.pm/packages/eventrelay_client), the package can be installed
by adding `eventrelay_client` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    # until we start releasing versioned updates to the package you should 
    # pull from the github repo
    {:eventrelay_client, github: "eventrelay/eventrelay_client_elixir", branch: "main"}
    # {:eventrelay_client, "~> 0.1.0"}
  ]
end
```

## Configuration

If using the `Audit` module please make sure to set the `ER_CLIENT_HMAC_SECRET`. This value is used to calculate SHA256 HMAC for the event data to ensure the authenticity and integrity of the event data. Whatever value you set for this don't lose it otherwise you will not be able to verify the authenticity and integrity your audit events in EventRelay.

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Docs can
be found at <https://hexdocs.pm/eventrelay_client/readme.html>.


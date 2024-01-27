defmodule EventRelay.Context do
  @moduledoc """
  Context is a struct that contains data
  """

  @typedoc """
  EventRelay.Context
  """
  @type t :: %__MODULE__{
          channel: GRPC.Channel.t() | nil
        }

  defstruct channel: nil

  alias __MODULE__

  @doc """
  Constructs a new Context

    ## Options

    #{NimbleOptions.docs(EventRelay.Channel.Options.definition())}
  """
  @spec new(keyword()) :: Context.t()
  def new(opts \\ []) do
    %Context{channel: EventRelay.Channel.new(opts)}
  end
end

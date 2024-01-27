defmodule EventRelay.Context do
  @moduledoc """
  Context is a struct that contains data
  """

  @typedoc """
  EventRelay.Context
  """
  @type t :: %__MODULE__{
          channel: GRPC.Channel.t()
        }

  defstruct channel: nil
  alias __MODULE__

  def new(opts \\ []) do
    %Context{channel: EventRelay.Channel.new(opts)}
  end
end

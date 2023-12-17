defmodule EventRelay.Context do
  defstruct channel: nil
  alias __MODULE__

  def new(opts \\ []) do
    %Context{channel: EventRelay.Channel.new(opts)}
  end
end

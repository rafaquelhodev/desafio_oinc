defmodule DesafioOinc.Blog.Events.TagCreated do
  @derive Jason.Encoder
  defstruct [:uuid, :name]
end

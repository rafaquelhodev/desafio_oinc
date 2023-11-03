defmodule DesafioOinc.Blog.Events.TagUpdated do
  @derive Jason.Encoder
  defstruct [:uuid, :name]
end

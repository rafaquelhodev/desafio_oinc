defmodule DesafioOinc.Blog.Events.PostUpdated do
  @derive Jason.Encoder
  defstruct [:uuid, :title, :text]
end

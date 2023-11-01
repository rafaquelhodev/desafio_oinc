defmodule DesafioOinc.Blog.Events.PostCreated do
  @derive Jason.Encoder
  defstruct [:uuid, :title, :text, :likes, :dislikes, :tags]
end

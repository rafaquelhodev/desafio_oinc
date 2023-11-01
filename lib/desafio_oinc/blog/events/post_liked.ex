defmodule DesafioOinc.Blog.Events.PostLiked do
  @derive Jason.Encoder
  defstruct [:uuid, :likes]
end

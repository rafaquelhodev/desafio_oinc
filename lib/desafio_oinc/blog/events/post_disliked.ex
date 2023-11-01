defmodule DesafioOinc.Blog.Events.PostDisliked do
  @derive Jason.Encoder
  defstruct [:uuid, :dislikes]
end

defmodule DesafioOinc.Blog.Events.CommentCreated do
  @derive Jason.Encoder
  defstruct [:uuid, :post_uuid, :text]
end

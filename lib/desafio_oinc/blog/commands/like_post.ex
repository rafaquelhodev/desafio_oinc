defmodule DesafioOinc.Blog.Commands.LikePost do
  defstruct post_uuid: nil

  alias DesafioOinc.Blog.Commands.LikePost

  def assign_uuid(%LikePost{} = command, uuid) do
    %LikePost{command | post_uuid: uuid}
  end
end

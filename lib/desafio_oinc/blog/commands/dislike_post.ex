defmodule DesafioOinc.Blog.Commands.DislikePost do
  defstruct post_uuid: nil

  alias DesafioOinc.Blog.Commands.DislikePost

  def assign_uuid(%DislikePost{} = command, uuid) do
    %DislikePost{command | post_uuid: uuid}
  end
end

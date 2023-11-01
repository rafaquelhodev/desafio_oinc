defmodule DesafioOinc.Blog.Commands.AddPostTag do
  defstruct post_uuid: nil, new_tag_uuid: nil

  alias DesafioOinc.Blog.Commands.AddPostTag

  def assign_uuid(%AddPostTag{} = command, uuid) do
    %AddPostTag{command | post_uuid: uuid}
  end

  def assign_tag(%AddPostTag{} = command, tag_uuid) do
    %AddPostTag{command | new_tag_uuid: tag_uuid}
  end
end

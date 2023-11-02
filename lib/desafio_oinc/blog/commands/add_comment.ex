defmodule DesafioOinc.Blog.Commands.AddComment do
  defstruct comment_uuid: "", post_uuid: "", text: ""

  alias DesafioOinc.Blog.Commands.AddComment

  def assign_uuid(%AddComment{} = command, uuid) do
    %AddComment{command | comment_uuid: uuid}
  end

  def assign_post(%AddComment{} = command, post_uuid) do
    %AddComment{command | post_uuid: post_uuid}
  end

  def add_comment(%AddComment{} = command, comment) do
    %AddComment{command | text: comment}
  end
end

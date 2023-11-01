defmodule DesafioOinc.Blog.Commands.CreatePost do
  defstruct post_uuid: "",
            title: "",
            text: "",
            tags: []

  alias DesafioOinc.Blog.Commands.CreatePost

  def assign_uuid(%CreatePost{} = command, uuid) do
    %CreatePost{command | post_uuid: uuid}
  end

  def add_title(%CreatePost{} = command, title) do
    %CreatePost{command | title: title}
  end

  def add_text(%CreatePost{} = command, text) do
    %CreatePost{command | text: text}
  end
end

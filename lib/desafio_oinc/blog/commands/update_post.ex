defmodule DesafioOinc.Blog.Commands.UpdatePost do
  defstruct post_uuid: "",
            title: "",
            text: "",
            tags: []

  alias DesafioOinc.Blog.Commands.UpdatePost

  def assign_uuid(%UpdatePost{} = command, uuid) do
    %UpdatePost{command | post_uuid: uuid}
  end

  def add_title(%UpdatePost{} = command, title) do
    %UpdatePost{command | title: title}
  end

  def add_text(%UpdatePost{} = command, text) do
    %UpdatePost{command | text: text}
  end
end

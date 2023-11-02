defmodule DesafioOinc.Fixtures do
  alias DesafioOinc.Blog

  def create_post(attrs \\ %{}) do
    attrs = Map.merge(%{title: "Nice title", text: "Nice text"}, attrs)

    {:ok, post} = Blog.create_post(attrs.title, attrs.text)
    post
  end

  def create_tag(attrs \\ %{}) do
    attrs = Map.merge(%{name: "New tag name"}, attrs)

    {:ok, tag} = Blog.create_tag(attrs.name)
    tag
  end
end

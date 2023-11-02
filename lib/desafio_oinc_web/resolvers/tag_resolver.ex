defmodule DesafioOincWeb.Resolvers.TagResolver do
  alias DesafioOinc.Blog

  # def get_post(_parent, %{uuid: uuid}, _resolution) do
  #   Blog.find_post(uuid)
  # end

  def get_tags(_parent, _args, _resolution) do
    Blog.get_tags()
  end

  def create_tag(_parent, %{name: name}, _resolution) do
    Blog.create_tag(name)
  end
end

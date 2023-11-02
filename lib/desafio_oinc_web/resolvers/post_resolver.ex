defmodule DesafioOincWeb.Resolvers.PostResolver do
  alias DesafioOinc.Blog

  def get_post(_parent, %{uuid: uuid}, _resolution) do
    Blog.find_post(uuid)
  end

  def get_posts(_parent, %{limit: limit, page: page}, _resolution) do
    Blog.get_posts(limit, page)
  end

  def create_post(_parent, %{title: title, text: text}, _resolution) do
    Blog.create_post(title, text)
  end

  def add_tag_post(_parent, %{post_uuid: post_uuid, tag_uuid: tag_uuid}, _resolution) do
    Blog.add_tag_to_post(post_uuid, tag_uuid)
  end

  def like_post(_parent, %{uuid: uuid}, _resolution) do
    Blog.like_post(uuid)
  end

  def dislike_post(_parent, %{uuid: uuid}, _resolution) do
    Blog.dislike_post(uuid)
  end
end

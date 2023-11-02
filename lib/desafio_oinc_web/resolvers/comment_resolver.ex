defmodule DesafioOincWeb.Resolvers.CommentResolver do
  alias DesafioOinc.Blog

  def create_comment(_parent, %{post_uuid: post_uuid, text: text}, _resolution) do
    Blog.comment_post(post_uuid, text)
  end
end

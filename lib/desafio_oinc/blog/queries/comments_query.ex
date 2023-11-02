defmodule DesafioOinc.Blog.Queries.CommentsQuery do
  import Ecto.Query

  alias DesafioOinc.Blog.Projections.Comment

  def comments_from_post(post_uuid) do
    from(c in Comment, where: c.post_uuid == ^post_uuid)
  end
end

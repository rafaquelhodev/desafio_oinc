defmodule DesafioOinc.Blog.Queries.PostsQuery do
  import Ecto.Query

  alias DesafioOinc.Blog.Projections.Post

  def get_posts(limit, page) do
    offset = (page - 1) * limit

    from(p in Post)
    |> limit(^limit)
    |> offset(^offset)
    |> order_by(:inserted_at)
  end
end

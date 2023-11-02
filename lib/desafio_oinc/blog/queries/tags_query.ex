defmodule DesafioOinc.Blog.Queries.TagsQuery do
  import Ecto.Query

  alias DesafioOinc.Blog.Aggregates.Tag
  alias DesafioOinc.Blog.Projections.Tag

  def get_tags() do
    from(p in Tag)
    |> order_by(:name)
  end
end

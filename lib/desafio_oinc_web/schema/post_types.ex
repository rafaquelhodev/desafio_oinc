defmodule DesafioOincWeb.Schema.PostTypes do
  use Absinthe.Schema.Notation

  alias DesafioOinc.Blog

  object :post do
    field :uuid, :string
    field :text, :string
    field :title, :string

    field :comments, list_of(:comment) do
      resolve(fn post, _, _ ->
        comments = Blog.get_comments_from_post(post.uuid)
        {:ok, comments}
      end)
    end

    field :tags, list_of(:tag) do
      resolve(fn post, _, _ ->
        tags = Blog.get_post_tags(post)
        {:ok, tags}
      end)
    end

    field :rating, :rating do
      resolve(fn post, _, _ ->
        rating = Blog.get_post_rating(post)
        {:ok, rating}
      end)
    end
  end

  object :rating do
    field :likes, :integer
    field :dislikes, :integer
  end
end

defmodule DesafioOinc.Blog.Projections.Post do
  use Ecto.Schema

  alias DesafioOinc.Blog.Projections.PostTag
  alias DesafioOinc.Blog.Projections.Rating
  alias DesafioOinc.Blog.Projections.Comment

  @primary_key {:uuid, :binary_id, autogenerate: false}
  @foreign_key_type :binary_id
  schema "posts" do
    field :text, :string
    field :title, :string

    has_many(:comments, Comment)
    has_many(:post_tags, PostTag)
    has_many(:tags, through: [:post_tags, :tag])
    has_one(:rating, Rating)

    timestamps()
  end
end

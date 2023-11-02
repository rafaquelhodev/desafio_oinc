defmodule DesafioOinc.Blog.Projections.Rating do
  use Ecto.Schema

  alias DesafioOinc.Blog.Projections.Post

  @primary_key false

  schema "post_ratings" do
    field :dislikes, :integer
    field :likes, :integer

    belongs_to(:post, Post,
      type: :binary_id,
      foreign_key: :post_uuid,
      references: :uuid,
      primary_key: true
    )

    timestamps()
  end
end

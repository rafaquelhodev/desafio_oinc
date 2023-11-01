defmodule DesafioOinc.Blog.Projections.Rating do
  use Ecto.Schema
  import Ecto.Changeset

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

  @doc false
  def changeset(rating, attrs) do
    rating
    |> cast(attrs, [:likes, :dislikes])
    |> validate_required([:likes, :dislikes])
  end
end

defmodule DesafioOinc.Blog.Projections.PostTag do
  use Ecto.Schema
  import Ecto.Changeset

  alias DesafioOinc.Blog.Projections.Tag
  alias DesafioOinc.Blog.Projections.Post

  @primary_key false
  schema "post_tags" do
    belongs_to(:post, Post,
      type: :binary_id,
      foreign_key: :post_uuid,
      references: :uuid,
      primary_key: true
    )

    belongs_to(:tag, Tag,
      type: :binary_id,
      foreign_key: :tag_uuid,
      references: :uuid,
      primary_key: true
    )

    timestamps()
  end
end

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

  @doc false
  def changeset(post_tag, attrs) do
    post_tag
    |> cast(attrs, [:post_uuid, :tag_uuid])
    |> validate_required([:post_uuid, :tag_uuid])
    |> foreign_key_constraint(:post_tags, name: "post_tags_tag_uuid_fkey")
  end
end

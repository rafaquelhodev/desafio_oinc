defmodule DesafioOinc.Blog.Projections.Comment do
  use Ecto.Schema
  import Ecto.Changeset

  alias DesafioOinc.Blog.Projections.Post

  @primary_key {:uuid, :binary_id, autogenerate: false}
  @foreign_key_type :binary_id
  schema "comments" do
    field :text, :string

    belongs_to(:post, Post,
      type: :binary_id,
      foreign_key: :post_uuid,
      references: :uuid
    )

    timestamps()
  end

  @doc false
  def changeset(comment, attrs) do
    comment
    |> cast(attrs, [:text])
    |> validate_required([:text])
  end
end

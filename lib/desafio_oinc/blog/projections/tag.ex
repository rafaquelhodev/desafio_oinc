defmodule DesafioOinc.Blog.Projections.Tag do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:uuid, :binary_id, autogenerate: false}
  @foreign_key_type :binary_id
  schema "tags" do
    field :name, :string

    timestamps()
  end
end

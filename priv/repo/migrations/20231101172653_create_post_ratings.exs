defmodule DesafioOinc.Repo.Migrations.CreatePostRatings do
  use Ecto.Migration

  def change do
    create table(:post_ratings, primary_key: false) do
      add :likes, :integer
      add :dislikes, :integer

      add :post_uuid, references(:posts, type: :uuid, column: :uuid, on_delete: :nothing),
        primary_key: true

      timestamps()
    end

    create index(:post_ratings, [:post_uuid])
  end
end

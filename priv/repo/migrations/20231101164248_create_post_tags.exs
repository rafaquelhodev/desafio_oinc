defmodule DesafioOinc.Repo.Migrations.CreatePostTags do
  use Ecto.Migration

  def change do
    create table(:post_tags, primary_key: false) do
      add :post_uuid, references(:posts, type: :uuid, column: :uuid, on_delete: :nothing),
        primary_key: true

      add :tag_uuid, references(:tags, type: :uuid, column: :uuid, on_delete: :nothing),
        primary_key: true

      timestamps()
    end

    create index(:post_tags, [:post_uuid])
    create index(:post_tags, [:tag_uuid])
  end
end

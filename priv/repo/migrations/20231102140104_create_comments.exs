defmodule DesafioOinc.Repo.Migrations.CreateComments do
  use Ecto.Migration

  def change do
    create table(:comments, primary_key: false) do
      add :uuid, :binary_id, primary_key: true
      add :text, :text
      add :post_uuid, references(:posts, on_delete: :nothing, type: :binary_id, column: :uuid)

      timestamps()
    end

    create index(:comments, [:post_uuid])
  end
end

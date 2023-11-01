defmodule DesafioOinc.Repo.Migrations.CreatePosts do
  use Ecto.Migration

  def change do
    create table(:posts, primary_key: false) do
      add :uuid, :binary_id, primary_key: true
      add :title, :text
      add :text, :string

      timestamps()
    end
  end
end

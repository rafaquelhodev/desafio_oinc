defmodule DesafioOinc.Repo.Migrations.CreateTags do
  use Ecto.Migration

  def change do
    create table(:tags, primary_key: false) do
      add :uuid, :binary_id, primary_key: true
      add :name, :text

      timestamps()
    end
  end
end

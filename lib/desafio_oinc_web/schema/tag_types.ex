defmodule DesafioOincWeb.Schema.TagTypes do
  use Absinthe.Schema.Notation

  object :tag do
    field :uuid, :string
    field :name, :string
  end
end

defmodule DesafioOincWeb.Schema.CommentTypes do
  use Absinthe.Schema.Notation

  object :comment do
    field :uuid, :string
    field :text, :string
  end
end

defmodule DesafioOincWeb.Schema.CommentTypes do
  use Absinthe.Schema.Notation

  object :comment do
    field :uuid, :string
    field :text, :string
    field :post_uuid, :string
  end
end

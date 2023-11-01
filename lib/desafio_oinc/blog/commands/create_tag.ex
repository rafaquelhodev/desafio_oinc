defmodule DesafioOinc.Blog.Commands.CreateTag do
  defstruct tag_uuid: "",
            name: ""

  alias DesafioOinc.Blog.Commands.CreateTag

  def assign_uuid(%CreateTag{} = command, uuid) do
    %CreateTag{command | tag_uuid: uuid}
  end

  def add_name(%CreateTag{} = command, name) do
    %CreateTag{command | name: name}
  end
end

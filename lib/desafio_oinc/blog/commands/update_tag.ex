defmodule DesafioOinc.Blog.Commands.UpdateTag do
  defstruct tag_uuid: "",
            name: ""

  alias DesafioOinc.Blog.Commands.UpdateTag

  def assign_uuid(%UpdateTag{} = command, uuid) do
    %UpdateTag{command | tag_uuid: uuid}
  end

  def add_name(%UpdateTag{} = command, name) do
    %UpdateTag{command | name: name}
  end
end

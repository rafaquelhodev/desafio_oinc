defmodule DesafioOinc.Blog.Aggregates.Tag do
  defstruct uuid: nil, name: nil

  alias DesafioOinc.Blog.Aggregates.Tag

  alias DesafioOinc.Blog.Commands.CreateTag

  alias DesafioOinc.Blog.Events.TagCreated

  def execute(%Tag{uuid: nil}, %CreateTag{} = command) do
    %TagCreated{
      uuid: command.tag_uuid,
      name: command.name
    }
  end

  def apply(%Tag{}, %TagCreated{} = event) do
    %Tag{uuid: event.uuid, name: event.name}
  end
end

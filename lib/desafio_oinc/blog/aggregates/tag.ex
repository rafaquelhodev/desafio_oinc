defmodule DesafioOinc.Blog.Aggregates.Tag do
  defstruct uuid: nil, name: nil

  alias DesafioOinc.Blog.Aggregates.Tag

  alias DesafioOinc.Blog.Commands.CreateTag
  alias DesafioOinc.Blog.Commands.UpdateTag

  alias DesafioOinc.Blog.Events.TagCreated
  alias DesafioOinc.Blog.Events.TagUpdated

  def execute(%Tag{uuid: nil}, %CreateTag{} = command) do
    %TagCreated{
      uuid: command.tag_uuid,
      name: command.name
    }
  end

  def execute(%Tag{uuid: uuid}, %UpdateTag{} = command) do
    %TagUpdated{
      uuid: uuid,
      name: command.name
    }
  end

  def apply(%Tag{}, %TagCreated{} = event) do
    %Tag{uuid: event.uuid, name: event.name}
  end

  def apply(%Tag{} = tag, %TagUpdated{} = event) do
    %Tag{tag | name: event.name}
  end
end

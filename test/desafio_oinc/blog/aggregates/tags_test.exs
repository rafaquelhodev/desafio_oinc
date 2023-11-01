defmodule DesafioOinc.Blog.Aggregates.TagsTest do
  use DesafioOinc.DataCase, async: false

  import Commanded.Assertions.EventAssertions

  alias DesafioOinc.App

  alias DesafioOinc.Blog.Commands.CreateTag

  alias DesafioOinc.Blog.Events.TagCreated

  describe "CreateTag command" do
    test "emits a TagCreated event" do
      uuid = Ecto.UUID.generate()

      command =
        %CreateTag{}
        |> CreateTag.assign_uuid(uuid)
        |> CreateTag.add_name("Tag name")

      :ok = App.dispatch(command, consistency: :strong)

      wait_for_event(App, TagCreated, fn event -> event.uuid == uuid end)
    end
  end
end

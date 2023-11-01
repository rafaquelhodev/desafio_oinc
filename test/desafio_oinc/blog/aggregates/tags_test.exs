defmodule DesafioOinc.Blog.Aggregates.TagsTest do
  use DesafioOinc.DataCase, async: true

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

      :ok = App.dispatch(command)

      assert_receive_event(App, TagCreated, fn event ->
        assert event.uuid == uuid
        assert event.name == "Tag name"
      end)
    end
  end
end

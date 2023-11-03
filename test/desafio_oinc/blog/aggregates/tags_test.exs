defmodule DesafioOinc.Blog.Aggregates.TagsTest do
  use DesafioOinc.DataCase, async: false

  alias Commanded.Aggregates.Aggregate

  alias DesafioOinc.App

  alias DesafioOinc.Blog.Aggregates.Tag
  alias DesafioOinc.Blog.Commands.CreateTag

  describe "CreateTag command" do
    test "emits a TagCreated event" do
      uuid = Ecto.UUID.generate()

      command =
        %CreateTag{}
        |> CreateTag.assign_uuid(uuid)
        |> CreateTag.add_name("Tag name")

      :ok = App.dispatch(command, consistency: :strong)

      assert Aggregate.aggregate_state(App, Tag, uuid) == %Tag{
               uuid: uuid,
               name: "Tag name"
             }
    end
  end
end

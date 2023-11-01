defmodule DesafioOinc.Blog.Aggregates.PostTest do
  use DesafioOinc.DataCase, async: true

  import Commanded.Assertions.EventAssertions

  alias DesafioOinc.App

  alias DesafioOinc.Blog.Commands.CreatePost

  alias DesafioOinc.Blog.Events.PostCreated

  describe "CreatePost command" do
    test "emits a PostCreated event" do
      uuid = Ecto.UUID.generate()

      command =
        %CreatePost{}
        |> CreatePost.assign_uuid(uuid)
        |> CreatePost.add_title("My title")
        |> CreatePost.add_text("My text")

      :ok = App.dispatch(command)

      assert_receive_event(App, PostCreated, fn event ->
        assert event.uuid == uuid
        assert event.title == "My title"
        assert event.text == "My text"
      end)
    end

    test "returns an error when there is an empty text" do
      uuid = Ecto.UUID.generate()

      command =
        %CreatePost{}
        |> CreatePost.assign_uuid(uuid)
        |> CreatePost.add_title("My title")
        |> CreatePost.add_text("")

      assert {:error, :invalid_post_content} = App.dispatch(command)
    end

    test "returns an error when there is an empty title" do
      uuid = Ecto.UUID.generate()

      command =
        %CreatePost{}
        |> CreatePost.assign_uuid(uuid)
        |> CreatePost.add_title("")
        |> CreatePost.add_text("My text")

      assert {:error, :invalid_post_content} = App.dispatch(command)
    end
  end
end

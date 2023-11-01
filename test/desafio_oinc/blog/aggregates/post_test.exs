defmodule DesafioOinc.Blog.Aggregates.PostTest do
  use DesafioOinc.DataCase, async: true

  import Commanded.Assertions.EventAssertions
  alias Commanded.Aggregates.Aggregate

  alias DesafioOinc.App

  alias DesafioOinc.Blog.Aggregates.Post

  alias DesafioOinc.Blog.Commands.CreatePost
  alias DesafioOinc.Blog.Commands.AddPostTag

  alias DesafioOinc.Blog.Events.PostCreated
  alias DesafioOinc.Blog.Events.PostTagAdded

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

  describe "AddPostTag command" do
    test "adds a tag into the Post aggregate" do
      uuid = Ecto.UUID.generate()

      create_post_command =
        %CreatePost{}
        |> CreatePost.assign_uuid(uuid)
        |> CreatePost.add_title("My title")
        |> CreatePost.add_text("My text")

      :ok = App.dispatch(create_post_command, consistency: :strong)

      tag_01 = Ecto.UUID.generate()
      tag_02 = Ecto.UUID.generate()

      add_tag_01_command =
        %AddPostTag{} |> AddPostTag.assign_uuid(uuid) |> AddPostTag.assign_tag(tag_01)

      add_tag_02_command =
        %AddPostTag{} |> AddPostTag.assign_uuid(uuid) |> AddPostTag.assign_tag(tag_02)

      :ok = App.dispatch(add_tag_01_command, consistency: :strong)

      assert_receive_event(App, PostTagAdded, fn event ->
        assert event.uuid == uuid
        assert event.added_tag_uuid == tag_01
      end)

      :ok = App.dispatch(add_tag_02_command)

      wait_for_event(App, PostTagAdded, fn event -> event.added_tag_uuid == tag_02 end)

      assert Aggregate.aggregate_state(App, Post, uuid) == %Post{
               uuid: uuid,
               tags: MapSet.new([tag_01, tag_02]),
               title: "My title",
               text: "My text"
             }
    end
  end
end

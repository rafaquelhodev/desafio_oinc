defmodule DesafioOinc.Blog.Aggregates.CommentTest do
  use DesafioOinc.DataCase

  import Commanded.Assertions.EventAssertions

  alias DesafioOinc.App

  alias DesafioOinc.Blog.Commands.AddComment
  alias DesafioOinc.Blog.Commands.CreatePost

  alias DesafioOinc.Blog.Events.CommentCreated

  describe "AddComment command" do
    test "emits a PostCreated event" do
      post_uuid = Ecto.UUID.generate()

      command =
        %CreatePost{}
        |> CreatePost.assign_uuid(post_uuid)
        |> CreatePost.add_title("My title")
        |> CreatePost.add_text("My text")

      :ok = App.dispatch(command, consistency: :strong)

      uuid = Ecto.UUID.generate()

      command =
        %AddComment{}
        |> AddComment.assign_uuid(uuid)
        |> AddComment.assign_post(post_uuid)
        |> AddComment.add_comment("My comment")

      :ok = App.dispatch(command, consistency: :strong)

      wait_for_event(App, CommentCreated, fn event -> event.uuid == uuid end)
    end
  end
end

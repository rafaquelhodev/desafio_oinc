defmodule DesafioOinc.Blog.Aggregates.CommentTest do
  alias DesafioOinc.Blog.Aggregates.Comment
  use DesafioOinc.DataCase

  alias Commanded.Aggregates.Aggregate

  alias DesafioOinc.App

  alias DesafioOinc.Blog.Commands.AddComment
  alias DesafioOinc.Blog.Commands.CreatePost

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

      assert Aggregate.aggregate_state(App, Comment, uuid) == %Comment{
               uuid: uuid,
               text: "My comment",
               post_uuid: post_uuid
             }
    end

    test "should return error when comment is bigger than 254 chars" do
      post_uuid = Ecto.UUID.generate()

      command =
        %CreatePost{}
        |> CreatePost.assign_uuid(post_uuid)
        |> CreatePost.add_title("My title")
        |> CreatePost.add_text("My text")

      :ok = App.dispatch(command, consistency: :strong)

      uuid = Ecto.UUID.generate()

      comment = """
      ne61b4cq82mzvj98gmbkprpb0m2wh4nxtdex1i91n4k3febzp1wjp335wuxn92v8tbzy7xjri53a3
      zkjjnjb1gr00x6m6cffwy4dv4ntta42drfifhpgy6dgapvbf7eei7vy09j4b277wmg5jbj1qm2q0tc
      uedpcir5ryanpfw2ayf6kghriq1ejdtmqe8za4gyz5ppn7cbbg21hbh7f7wncj8wv25vrx19cbvwu7
      3rf2e7b7gbnqv92v5vnn4qh1234515161
      """

      command =
        %AddComment{}
        |> AddComment.assign_uuid(uuid)
        |> AddComment.assign_post(post_uuid)
        |> AddComment.add_comment(comment)

      assert {:error, :comment_too_big} = App.dispatch(command, consistency: :strong)
    end
  end
end

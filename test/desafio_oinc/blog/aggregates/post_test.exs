defmodule DesafioOinc.Blog.Aggregates.PostTest do
  use DesafioOinc.DataCase, async: false

  alias Commanded.Aggregates.Aggregate

  alias DesafioOinc.App

  alias DesafioOinc.Blog.Aggregates.Post

  alias DesafioOinc.Blog.Commands.CreatePost
  alias DesafioOinc.Blog.Commands.CreateTag
  alias DesafioOinc.Blog.Commands.AddPostTag
  alias DesafioOinc.Blog.Commands.LikePost
  alias DesafioOinc.Blog.Commands.DislikePost

  describe "CreatePost command" do
    test "emits a PostCreated event" do
      uuid = Ecto.UUID.generate()

      command =
        %CreatePost{}
        |> CreatePost.assign_uuid(uuid)
        |> CreatePost.add_title("My title")
        |> CreatePost.add_text("My text")

      :ok = App.dispatch(command, consistency: :strong)

      assert Aggregate.aggregate_state(App, Post, uuid) == %Post{
               uuid: uuid,
               tags: MapSet.new(),
               title: "My title",
               text: "My text"
             }
    end

    test "returns an error when there is an empty text" do
      uuid = Ecto.UUID.generate()

      command =
        %CreatePost{}
        |> CreatePost.assign_uuid(uuid)
        |> CreatePost.add_title("My title")
        |> CreatePost.add_text("")

      assert {:error, :invalid_post_content} = App.dispatch(command, consistency: :strong)
    end

    test "returns an error when there is an empty title" do
      uuid = Ecto.UUID.generate()

      command =
        %CreatePost{}
        |> CreatePost.assign_uuid(uuid)
        |> CreatePost.add_title("")
        |> CreatePost.add_text("My text")

      assert {:error, :invalid_post_content} = App.dispatch(command, consistency: :strong)
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

      create_tag_01_command =
        %CreateTag{}
        |> CreateTag.assign_uuid(tag_01)
        |> CreateTag.add_name("Tag name")

      create_tag_02_command =
        %CreateTag{}
        |> CreateTag.assign_uuid(tag_02)
        |> CreateTag.add_name("Tag name")

      :ok = App.dispatch(create_tag_01_command, consistency: :strong)
      :ok = App.dispatch(create_tag_02_command, consistency: :strong)

      add_tag_01_command =
        %AddPostTag{} |> AddPostTag.assign_uuid(uuid) |> AddPostTag.assign_tag(tag_01)

      add_tag_02_command =
        %AddPostTag{} |> AddPostTag.assign_uuid(uuid) |> AddPostTag.assign_tag(tag_02)

      :ok = App.dispatch(add_tag_01_command, consistency: :strong)
      :ok = App.dispatch(add_tag_02_command, consistency: :strong)

      assert Aggregate.aggregate_state(App, Post, uuid) == %Post{
               uuid: uuid,
               tags: MapSet.new([tag_01, tag_02]),
               title: "My title",
               text: "My text"
             }
    end
  end

  describe "LikePost command" do
    test "increments the number of likes in a Post" do
      post_01_uuid = Ecto.UUID.generate()

      create_post_command =
        %CreatePost{}
        |> CreatePost.assign_uuid(post_01_uuid)
        |> CreatePost.add_title("My title")
        |> CreatePost.add_text("My text")

      :ok = App.dispatch(create_post_command, consistency: :strong)

      post_02_uuid = Ecto.UUID.generate()

      create_post_command =
        %CreatePost{}
        |> CreatePost.assign_uuid(post_02_uuid)
        |> CreatePost.add_title("My title")
        |> CreatePost.add_text("My text")

      :ok = App.dispatch(create_post_command, consistency: :strong)

      like_post_02_command = %LikePost{} |> LikePost.assign_uuid(post_02_uuid)

      :ok = App.dispatch(like_post_02_command, consistency: :strong)
      :ok = App.dispatch(like_post_02_command, consistency: :strong)

      assert Aggregate.aggregate_state(App, Post, post_02_uuid) == %Post{
               uuid: post_02_uuid,
               tags: MapSet.new(),
               title: "My title",
               text: "My text",
               likes: 2,
               dislikes: 0
             }

      assert Aggregate.aggregate_state(App, Post, post_01_uuid) == %Post{
               uuid: post_01_uuid,
               tags: MapSet.new(),
               title: "My title",
               text: "My text",
               likes: 0,
               dislikes: 0
             }
    end
  end

  describe "DislikePost command" do
    test "increments the number of dislikes in a Post" do
      post_01_uuid = Ecto.UUID.generate()

      create_post_command =
        %CreatePost{}
        |> CreatePost.assign_uuid(post_01_uuid)
        |> CreatePost.add_title("My title")
        |> CreatePost.add_text("My text")

      :ok = App.dispatch(create_post_command, consistency: :strong)

      post_02_uuid = Ecto.UUID.generate()

      create_post_command =
        %CreatePost{}
        |> CreatePost.assign_uuid(post_02_uuid)
        |> CreatePost.add_title("My title")
        |> CreatePost.add_text("My text")

      :ok = App.dispatch(create_post_command, consistency: :strong)

      dislike_post_02_command = %DislikePost{} |> DislikePost.assign_uuid(post_02_uuid)

      :ok = App.dispatch(dislike_post_02_command, consistency: :strong)
      :ok = App.dispatch(dislike_post_02_command, consistency: :strong)

      assert Aggregate.aggregate_state(App, Post, post_02_uuid) == %Post{
               uuid: post_02_uuid,
               tags: MapSet.new(),
               title: "My title",
               text: "My text",
               likes: 0,
               dislikes: 2
             }

      assert Aggregate.aggregate_state(App, Post, post_01_uuid) == %Post{
               uuid: post_01_uuid,
               tags: MapSet.new(),
               title: "My title",
               text: "My text",
               likes: 0,
               dislikes: 0
             }
    end
  end
end

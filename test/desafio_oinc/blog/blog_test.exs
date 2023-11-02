defmodule DesafioOinc.Blog.BlogTest do
  use DesafioOinc.DataCase

  alias DesafioOinc.Blog
  alias DesafioOinc.Repo

  describe "create_post/2" do
    test "creates a post with a ratings entity" do
      {:ok, post} = Blog.create_post("title", "text")

      assert not is_nil(post.uuid)
      assert post.title == "title"
      assert post.text == "text"

      post = Repo.preload(post, :rating)

      assert post.rating.likes == 0
      assert post.rating.dislikes == 0
    end
  end

  describe "create_tag/1" do
    test "creates a Tag projection" do
      {:ok, tag} = Blog.create_tag("Tag name")

      assert not is_nil(tag.uuid)
      assert tag.name == "Tag name"
    end
  end

  describe "add_tag_to_post/2" do
    test "links a post to a tag" do
      {:ok, post} = Blog.create_post("title", "text")

      {:ok, tag} = Blog.create_tag("Tag name")

      {:ok, post} = Blog.add_tag_to_post(post.uuid, tag.uuid)

      tags = post |> Repo.preload(:tags) |> Map.get(:tags)

      assert length(tags) == 1
      assert tags |> List.first() |> Map.get(:uuid) == tag.uuid
    end
  end

  describe "like_post/1" do
    test "should increase the number of likes in a post" do
      {:ok, post} = Blog.create_post("title", "text")

      Blog.like_post(post.uuid)
      {:ok, post} = Blog.like_post(post.uuid)

      assert post |> Repo.preload(:rating) |> Map.get(:rating) |> Map.get(:likes) == 2
    end
  end

  describe "dislike_post/1" do
    test "should increase the number of dislikes in a post" do
      {:ok, post} = Blog.create_post("title", "text")

      Blog.dislike_post(post.uuid)
      {:ok, post} = Blog.dislike_post(post.uuid)

      assert post |> Repo.preload(:rating) |> Map.get(:rating) |> Map.get(:dislikes) == 2
    end
  end

  describe "comment_post/1" do
    test "should comment an existing post" do
      {:ok, post} = Blog.create_post("title", "text")

      {:ok, comment} = Blog.comment_post(post.uuid, "my new comment")

      assert comment.text == "my new comment"
      assert comment.post_uuid == post.uuid
    end
  end
end

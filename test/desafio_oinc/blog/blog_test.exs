defmodule DesafioOinc.Blog.BlogTest do
  use DesafioOinc.DataCase

  alias DesafioOinc.Blog
  alias DesafioOinc.Repo

  describe "create_post/2" do
    test "creates a post with a ratings entity" do
      post = Blog.create_post("title", "text")

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
      tag = Blog.create_tag("Tag name")

      assert not is_nil(tag.uuid)
      assert tag.name == "Tag name"
    end
  end

  describe "add_tag_to_post/2" do
    test "links a post to a tag" do
      post = Blog.create_post("title", "text")

      tag = Blog.create_tag("Tag name")

      post = Blog.add_tag_to_post(post.uuid, tag.uuid)

      tags = post |> Repo.preload(:tags) |> Map.get(:tags)

      assert length(tags) == 1
      assert tags |> List.first() |> Map.get(:uuid) == tag.uuid
    end
  end
end

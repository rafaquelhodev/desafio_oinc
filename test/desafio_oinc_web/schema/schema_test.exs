defmodule DesafioOincWeb.Schema.SchemaTest do
  use DesafioOincWeb.ConnCase

  import DesafioOinc.Fixtures

  alias DesafioOinc.Blog

  alias DesafioOinc.Repo

  @post_query """
  query post($uuid: String!) {
    post(uuid: $uuid) {
      uuid
      title
      text
      comments {
        uuid
        text
      }
      tags {
        uuid
        name
      }
      rating {
        likes
        dislikes
      }
    }
  }
  """

  describe "post query" do
    test "gets a post", %{conn: conn} do
      post = create_post(%{title: "new title", text: "new text"})
      tag = create_tag(%{name: "new tag"})

      Blog.add_tag_to_post(post.uuid, tag.uuid)

      conn =
        post(conn, "/graphql", %{
          "query" => @post_query,
          "variables" => %{uuid: post.uuid}
        })

      assert %{
               "data" => %{"post" => got_post}
             } = json_response(conn, 200)

      assert got_post["uuid"] == post.uuid
      assert got_post["title"] == "new title"
      assert got_post["text"] == "new text"

      assert got_post["tags"] == [%{"uuid" => tag.uuid, "name" => "new tag"}]
      assert got_post["rating"] == %{"likes" => 0, "dislikes" => 0}
    end
  end

  @posts_query """
  query posts($limit: Int, $page: Int) {
    posts(limit: $limit, page: $page) {
      uuid
      title
      text
    }
  }
  """

  describe "posts query" do
    test "gets a list of posts", %{conn: conn} do
      post_01 = create_post(%{title: "title 01", text: "new text"})
      post_02 = create_post(%{title: "title 02", text: "new text"})

      conn =
        post(conn, "/graphql", %{
          "query" => @posts_query,
          "variables" => %{page: 1}
        })

      assert %{
               "data" => %{"posts" => got_posts}
             } = json_response(conn, 200)

      assert length(got_posts) == 2

      assert post_01.uuid == List.first(got_posts) |> Map.get("uuid")
      assert post_02.uuid == List.last(got_posts) |> Map.get("uuid")
    end
  end

  @tags_query """
  query tags {
    tags {
      uuid
      name
    }
  }
  """

  describe "tags query" do
    test "gets a list of all tags", %{conn: conn} do
      tag_01 = create_tag(%{name: "new tag"})
      tag_02 = create_tag(%{name: "new tag"})

      conn =
        post(conn, "/graphql", %{
          "query" => @tags_query,
          "variables" => %{}
        })

      assert %{
               "data" => %{"tags" => got_tags}
             } = json_response(conn, 200)

      assert length(got_tags) == 2
      assert tag_01.uuid == List.first(got_tags) |> Map.get("uuid")
      assert tag_02.uuid == List.last(got_tags) |> Map.get("uuid")
    end
  end

  @create_post_mutation """
  mutation createPost($text: String!, $title: String!) {
    createPost(text: $text, title: $title) {
      uuid
      text
      title
    }
  }
  """
  describe "create post mutation" do
    test "creates a post", %{conn: conn} do
      conn =
        post(conn, "/graphql", %{
          "query" => @create_post_mutation,
          "variables" => %{text: "new text", title: "new title"}
        })

      assert %{
               "data" => %{"createPost" => got_post}
             } = json_response(conn, 200)

      assert got_post["text"] == "new text"
      assert got_post["title"] == "new title"
    end
  end

  @create_tag_mutation """
  mutation createTag($name: String!) {
    createTag(name: $name){
      uuid
      name
    }
  }
  """
  describe "create tag mutation" do
    test "creates a new tag", %{conn: conn} do
      conn =
        post(conn, "/graphql", %{
          "query" => @create_tag_mutation,
          "variables" => %{name: "my tag name"}
        })

      assert %{
               "data" => %{"createTag" => got_tag}
             } = json_response(conn, 200)

      assert got_tag["name"] == "my tag name"
    end
  end

  @add_tag_post_mutation """
  mutation addTagPost($post_uuid: String!, $tag_uuid: String!) {
    addTagPost(post_uuid: $post_uuid, tag_uuid: $tag_uuid){
      uuid
      text
      tags {
        uuid
        name
      }
    }
  }
  """
  describe "add tag post mutation" do
    test "adds a tag to a post", %{conn: conn} do
      post = create_post(%{title: "new title", text: "new text"})
      tag = create_tag(%{name: "new tag"})

      conn =
        post(conn, "/graphql", %{
          "query" => @add_tag_post_mutation,
          "variables" => %{post_uuid: post.uuid, tag_uuid: tag.uuid}
        })

      assert %{
               "data" => %{"addTagPost" => got_post}
             } = json_response(conn, 200)

      assert got_post["uuid"] == post.uuid
      assert got_post["tags"] |> List.first() |> Map.get("uuid") == tag.uuid
    end
  end

  @add_comment_mutation """
  mutation addComment($post_uuid: String!, $text: String!) {
    addComment(post_uuid: $post_uuid, text: $text) {
      uuid
      text
    }
  }
  """
  describe "add comment mutation" do
    test "adds a comment to a post", %{conn: conn} do
      post = create_post(%{title: "new title", text: "new text"})

      conn =
        post(conn, "/graphql", %{
          "query" => @add_comment_mutation,
          "variables" => %{post_uuid: post.uuid, text: "new comment!"}
        })

      assert %{
               "data" => %{"addComment" => got_comment}
             } = json_response(conn, 200)

      assert got_comment["text"] == "new comment!"

      assert post
             |> Repo.preload(:comments)
             |> Map.get(:comments)
             |> List.first()
             |> Map.get(:uuid) ==
               got_comment["uuid"]
    end

    test "returns errors when post is too big", %{conn: conn} do
      post = create_post(%{title: "new title", text: "new text"})

      comment = """
      ne61b4cq82mzvj98gmbkprpb0m2wh4nxtdex1i91n4k3febzp1wjp335wuxn92v8tbzy7xjri53a3
      zkjjnjb1gr00x6m6cffwy4dv4ntta42drfifhpgy6dgapvbf7eei7vy09j4b277wmg5jbj1qm2q0tc
      uedpcir5ryanpfw2ayf6kghriq1ejdtmqe8za4gyz5ppn7cbbg21hbh7f7wncj8wv25vrx19cbvwu7
      3rf2e7b7gbnqv92v5vnn4qh1234515161
      """

      conn =
        post(conn, "/graphql", %{
          "query" => @add_comment_mutation,
          "variables" => %{post_uuid: post.uuid, text: comment}
        })

      assert %{
               "data" => %{"addComment" => nil},
               "errors" => [%{"message" => message}]
             } = json_response(conn, 200)

      assert message == "comment_too_big"
    end
  end

  @like_post_mutation """
  mutation likePost($uuid: String!) {
    likePost(uuid: $uuid) {
      uuid
      rating {
        likes
        dislikes
      }
    }
  }
  """
  describe "like post mutation" do
    test "increments the number of likes", %{conn: conn} do
      post = create_post(%{title: "new title", text: "new text"})

      conn =
        post(conn, "/graphql", %{
          "query" => @like_post_mutation,
          "variables" => %{uuid: post.uuid}
        })

      assert %{
               "data" => %{"likePost" => got_post}
             } = json_response(conn, 200)

      assert got_post["rating"]["likes"] == 1
      assert got_post["rating"]["dislikes"] == 0
    end
  end

  @dislike_post_mutation """
  mutation dislikePost($uuid: String!) {
    dislikePost(uuid: $uuid) {
      uuid
      rating {
        likes
        dislikes
      }
    }
  }
  """
  describe "dislike post mutation" do
    test "increments the number of dislikes", %{conn: conn} do
      post = create_post(%{title: "new title", text: "new text"})

      conn =
        post(conn, "/graphql", %{
          "query" => @dislike_post_mutation,
          "variables" => %{uuid: post.uuid}
        })

      assert %{
               "data" => %{"dislikePost" => got_post}
             } = json_response(conn, 200)

      assert got_post["rating"]["likes"] == 0
      assert got_post["rating"]["dislikes"] == 1
    end
  end
end

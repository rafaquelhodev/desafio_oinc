# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#

alias DesafioOinc.Blog

comments_texts = [
  "Lorem Ipsum is simply dummy text of the printing and typesetting industry.",
  "unknown printer took a galley of type and scrambled it to make a type specimen book",
  "It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged"
]

tags =
  Enum.map(1..9, fn i ->
    {:ok, tag} = Blog.create_tag("Tag ##{i}")
    tag
  end)

posts =
  Enum.map(1..5, fn i ->
    text = """
    Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s
    """

    {:ok, post} = Blog.create_post("Title #{i}", text)
    Blog.add_tag_to_post(post.uuid, Enum.random(tags) |> Map.get(:uuid))

    Enum.each(comments_texts, fn comment ->
      Blog.comment_post(post.uuid, comment)
    end)

    post
  end)

defmodule DesafioOincWeb.Schema do
  use Absinthe.Schema

  import_types(DesafioOincWeb.Schema.PostTypes)
  import_types(DesafioOincWeb.Schema.TagTypes)
  import_types(DesafioOincWeb.Schema.CommentTypes)

  alias DesafioOincWeb.Resolvers

  query do
    @desc "Get product by uuid"
    field :post, :post do
      arg(:uuid, non_null(:string))
      resolve(&Resolvers.PostResolver.get_post/3)
    end

    @desc "Get product by uuid"
    field :posts, list_of(:post) do
      arg(:limit, :integer, default_value: 100)
      arg(:page, :integer, default_value: 1)

      resolve(&Resolvers.PostResolver.get_posts/3)
    end

    @desc "Get all tags"
    field :tags, list_of(:tag) do
      resolve(&Resolvers.TagResolver.get_tags/3)
    end
  end

  mutation do
    @desc "Create a new post"
    field :create_post, :post do
      arg(:title, non_null(:string))
      arg(:text, non_null(:string))
      resolve(&Resolvers.PostResolver.create_post/3)
    end

    @desc "Create a new tag"
    field :create_tag, :tag do
      arg(:name, non_null(:string))
      resolve(&Resolvers.TagResolver.create_tag/3)
    end

    @desc "Add a tag to a post"
    field :add_tag_post, :post do
      arg(:post_uuid, non_null(:string))
      arg(:tag_uuid, non_null(:string))
      resolve(&Resolvers.PostResolver.add_tag_post/3)
    end

    @desc "Add a comment to a post"
    field :add_comment, :comment do
      arg(:post_uuid, non_null(:string))
      arg(:text, non_null(:string))
      resolve(&Resolvers.CommentResolver.create_comment/3)
    end

    @desc "Like a post"
    field :like_post, :post do
      arg(:uuid, non_null(:string))
      resolve(&Resolvers.PostResolver.like_post/3)
    end

    @desc "Dislike a post"
    field :dislike_post, :post do
      arg(:uuid, non_null(:string))
      resolve(&Resolvers.PostResolver.dislike_post/3)
    end
  end
end

defmodule Discuss.Comments do

    import Ecto.Query, warn: false
    alias Discuss.Repo
    alias Ecto
    alias Discuss.Comments.Comment

    def create_comment(attrs \\ %{},topic,user_id) do
        topic
        |> Ecto.build_assoc(:comments, user_id: user_id)
        |> Comment.changeset(attrs)
        |> Repo.insert()   
     end

     def load_user_from_comment(comment) do
        comment
        |> Repo.preload(:user)
     end
end
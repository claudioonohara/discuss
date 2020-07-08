defmodule Discuss.Users do

    import Ecto.Query, warn: false
    alias Discuss.Repo
  
    alias Discuss.Users.User

    def get_user!(id), do: Repo.get!(User, id)

    def get_by_email(User, email), do: Repo.get_by(User, email: email)

    def insert_or_update_user(changeset) do
        case  Repo.get_by(User, email: changeset.changes.email) do
          nil ->
            Repo.insert(changeset)
          user ->
            {:ok, user}
        end
      end
end
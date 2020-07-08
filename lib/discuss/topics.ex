defmodule Discuss.Topics do

    import Ecto.Query, warn: false
    alias Discuss.Repo
    alias Ecto
  
    alias Discuss.Topics.Topic

    def change_topic(%Topic{} = topic, attrs \\ %{}) do
        Topic.changeset(topic, attrs)
    end

    def create_topic(attrs \\ %{},user) do
        user
        |> Ecto.build_assoc(:topics)
        |> Topic.changeset(attrs)
        |> Repo.insert()        
     end

    def get_topic!(id), do: Repo.get!(Topic, id)

    def get_topic_with_comments(topic_id) do
        topic = Topic
        |> Repo.get(topic_id)
        |> Repo.preload(comments: [:user])
    end

    def update_topic(%Topic{} = topic, attrs) do
        topic
        |> Topic.changeset(attrs)
        |> Repo.update()
    end

    def delete_topic(%Topic{} = topic) do
        Repo.delete(topic)
    end
    
end
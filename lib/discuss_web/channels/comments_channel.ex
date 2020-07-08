defmodule DiscussWeb.CommentsChannel do
    use DiscussWeb, :channel
    alias Discuss.Topics
    alias Discuss.Topics.Topic 
    alias Discuss.Comments.Comment 
    alias Discuss.Comments

    def join("comments:" <> topic_id, _params, socket) do
        topic_id = String.to_integer(topic_id)
        topic = Topics.get_topic_with_comments(topic_id)
        {:ok, %{commnents: topic.comments}, assign(socket, :topic, topic)}
    end

    def handle_in(name,%{"content" => content}, socket) do
        topic = socket.assigns.topic
        user_id = socket.assigns.user_id
        case Comments.create_comment(%{content: content},topic,user_id) do
            {:ok, comment} ->
              broadcast!(socket, "comments:#{socket.assigns.topic.id}:new",
              %{comment: Comments.load_user_from_comment(comment)}
              )
              {:reply, :ok, socket}
            {:error, changeset} ->
              {:reply, {:error, %{errors: changeset}}, socket}
        end
    end
end
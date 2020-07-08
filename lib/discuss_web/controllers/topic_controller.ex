defmodule DiscussWeb.TopicController do
    
    use DiscussWeb, :controller

    alias Discuss.Topics
    alias Discuss.Topics.Topic

    plug DiscussWeb.Plugs.RequireAuth when action in [:new, :create, :edit, :update, :delete]
    plug :check_topic_owner when action in [:update, :edit, :delete]

    def index(conn, _params) do
        topics = Discuss.Repo.all(Topic)
        render conn, "index.html", topics: topics
    end

    def show(conn, %{"id" => topic_id}) do
        topic = Topics.get_topic!(topic_id)
        render conn, "show.html", topic: topic
      end

    def new(conn, _params) do
        #changeset = Topics.change_topic(%Topic{})
        #render(conn, "new.html", changeset: changeset)
        changeset = Topic.changeset(%Topic{},  %{})
        render conn, "new.html", changeset: changeset
    end

    def create(conn,  %{"topic" => topic_params}) do
        case Topics.create_topic(topic_params,conn.assigns.user) do
            {:ok, _topic} -> 
                conn
                |> put_flash(:info, "Topic Created")
                |> redirect(to: Routes.topic_path(conn, :index))
            {:error, changeset } -> 
                render conn, "new.html", changeset: changeset
        end
    end

    def edit(conn, %{"id" => topic_id}) do
        topic = Topics.get_topic!(topic_id)
        changeset = Topics.change_topic(topic)
        render(conn, "edit.html", topic: topic, changeset: changeset)
    end

    def update(conn, %{"id" => topic_id, "topic" => topic}) do
        old_topic = Topics.get_topic!(topic_id)
        changeset = Topic.changeset(old_topic, topic)
    
        case Topics.update_topic(old_topic, topic) do
          {:ok, _topic} ->
            conn
            |> put_flash(:info, "Topic Updated")
            |> redirect(to: Routes.topic_path(conn, :index))
          {:error, %Ecto.Changeset{} = changeset} ->
            render conn, "edit.html", topic: old_topic, changeset: changeset
        end
      end

      def delete(conn, %{"id" => topic_id}) do
        topic =  Topics.get_topic!(topic_id)
        {:ok, _user} = Topics.delete_topic(topic)
    
        conn
        |> put_flash(:info, "Topic deleted successfully.")
        |> redirect(to: Routes.topic_path(conn, :index))
      end

      def check_topic_owner(conn, _params) do
        %{params: %{"id" => topic_id}} = conn
      
        if Topics.get_topic!(topic_id).user_id == conn.assigns.user.id do
          conn
        else
          conn
          |> put_flash(:error, "You cannot edit that")
          |> redirect(to: Routes.topic_path(conn, :index))
          |> halt()
        end
      end

end
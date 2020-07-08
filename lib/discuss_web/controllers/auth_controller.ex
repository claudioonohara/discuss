defmodule DiscussWeb.AuthController do
    use DiscussWeb, :controller
    plug Ueberauth
  
    alias Discuss.Users.User
    alias Discuss.Users

    def callback(%{assigns: %{ueberauth_auth: auth}} = conn, params) do
      user_params = %{token: auth.credentials.token, email: auth.info.email, provider: "github"}
      changeset = User.changeset(%User{}, user_params)
  
      signin(conn, changeset)
    end

    def signout(conn, _params) do
      conn
      |> configure_session(drop: true)
      |> redirect(to: Routes.topic_path(conn, :index))
    end

    defp signin(conn, changeset) do
      case Users.insert_or_update_user(changeset) do
        {:ok, user} ->
          conn
          |> put_flash(:info, "Welcome back!")
          |> put_session(:user_id, user.id)
          |> redirect(to: Routes.topic_path(conn, :index))
        {:error, _reason} ->
          conn
          |> put_flash(:error, "Error signing in")
          |> redirect(to: Routes.topic_path(conn, :index))
      end
    end

  end
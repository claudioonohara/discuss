defmodule Discuss.Comments.Comment do
    use Ecto.Schema
    import Ecto.Changeset

    @derive {Jason.Encoder, only: [:content, :user]}

    schema "comments" do
        field :content, :string
        belongs_to :user, Discuss.Users.User
        belongs_to :topic, Discuss.Topics.Topic
    
        timestamps()
      end

    @doc false
    def changeset(struct, params \\ %{}) do
        struct
        |> cast(params, [:content])
        |> validate_required([:content])
      end
end
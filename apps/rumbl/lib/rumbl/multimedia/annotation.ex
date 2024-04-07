defmodule Rumbl.Multimedia.Annotation do
  use Ecto.Schema
  import Ecto.Changeset

  schema "annotations" do
    field :at, :integer
    field :body, :string
    belongs_to :user, Rumbl.Accounts.User
    belongs_to :video, Rumbl.Multimedia.Video

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(annotation, attrs) do
    annotation
    |> cast(attrs, [:body, :at, :user_id, :video_id])
    |> validate_required([:body, :at])
  end
end

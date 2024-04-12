defmodule Rumbl.HelperFixtures do
  alias Rumbl.{
    Accounts,
    Multimedia
  }

  @doc """
  Generate a user.
  """
  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        name: "Some User",
        username: "user#{System.unique_integer([:positive])}",
        password: attrs[:password] || "supersecret"
      })
      |> Accounts.register_user()

    user
  end

  @doc """
  Generate a video.
  """
  def video_fixture(%Accounts.User{} = user, attrs \\ %{}) do
    attrs =
      attrs
      |> Enum.into(%{
        description: "A description",
        title: "A title",
        url: "http://example.com"
      })

    {:ok, video} = Multimedia.create_video(user, attrs)

    video
  end
end

defmodule RumblWeb.VideoChannel do
  alias Rumbl.Multimedia
  use RumblWeb, :channel

  @impl true

  def join("videos:" <> video_id, payload, socket) do
    send(self(), :after_join)
    last_seen_id = payload["last_seen_id"] || 0
    video_id = String.to_integer(video_id)
    video = Rumbl.Multimedia.get_video!(video_id)

    annotations =
      video
      |> Multimedia.list_annotations(last_seen_id)
      |> Enum.map(fn item ->
        %{
          id: item.id,
          body: item.body,
          at: item.at,
          user: %{username: item.user.name, id: item.user.id}
        }
      end)

    {:ok, %{annotations: annotations}, assign(socket, :video_id, video_id)}
  end

  @impl true
  def handle_in(event, params, socket) do
    user = Rumbl.Accounts.get_user!(socket.assigns.user_id)
    handle_in(event, params, user, socket)
  end

  # It is also common to receive messages from the client and
  # broadcast to everyone in the current topic (video:lobby).
  def handle_in("new_annotation", params, user, socket) do
    case Rumbl.Multimedia.annotate_video(user, socket.assigns.video_id, params) do
      {:ok, annotation} ->
        broadcast!(socket, "new_annotation", %{
          id: annotation.id,
          user: %{username: user.name, id: user.id},
          body: annotation.body,
          at: annotation.at
        })

        {:reply, :ok, socket}

      {:error, changeset} ->
        {:reply, {:error, %{errors: changeset}}, socket}
    end
  end

  # receive OTP messages
  @impl true
  def handle_info(:after_join, socket) do
    push(socket, "presence_state", RumblWeb.Presence.list(socket))

    {:ok, _} =
      RumblWeb.Presence.track(
        socket,
        socket.assigns.user_id,
        %{device: "browser"}
      )

    {:noreply, socket}
  end

end

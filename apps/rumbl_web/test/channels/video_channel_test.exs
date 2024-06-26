defmodule RumblWeb.Channels.VideoChannelTest do
  use RumblWeb.ChannelCase
  import RumblWeb.TestHelpers

  setup do
    user = insert_user(name: "Gary")
    video = insert_video(user, title: "Testing")
    token = Phoenix.Token.sign(@endpoint, "user socket", user.id)
    {:ok, socket} = connect(RumblWeb.UserSocket, %{"token" => token})

    #see fix posted here https://github.com/phoenixframework/phoenix/issues/3619#issuecomment-642151609

    on_exit(fn ->
      :timer.sleep(10)
      for pid <- RumblWeb.Presence.fetchers_pids()  do
        ref = Process.monitor(pid)
        assert_receive {:DOWN, ^ref, _, _, _}, 1000
      end
    end)

    {:ok, socket: socket, user: user, video: video}
  end

  @tag :capture_log
  test "join replies with video annotations",
       %{socket: socket, video: vid, user: user} do
    for body <- ~w(one two) do
      Rumbl.Multimedia.annotate_video(user, vid.id, %{body: body, at: 0})
    end

    {:ok, reply, socket} = subscribe_and_join(socket, "videos:#{vid.id}", %{})

    assert socket.assigns.video_id == vid.id
    assert %{annotations: [%{body: "one"}, %{body: "two"}]} = reply
  end

  @tag :capture_log
  test "inserting new annotations", %{socket: socket, video: vid} do
    {:ok, _, socket} = subscribe_and_join(socket, "videos:#{vid.id}", %{})
    ref = push(socket, "new_annotation", %{body: "the body", at: 0})
    assert_reply(ref, :ok, %{})
    assert_broadcast("new_annotation", %{})
  end

  @tag :capture_log
  test "new annotations triggers InfoSys", %{socket: socket, video: vid} do
    insert_user(
      username: "wolfram",
      password: "supersecret"
    )

    {:ok, _, socket} = subscribe_and_join(socket, "videos:#{vid.id}", %{})
    ref = push(socket, "new_annotation", %{body: "1 + 1", at: 123})
    assert_reply(ref, :ok, %{})
    assert_broadcast("new_annotation", %{body: "1 + 1", at: 123})
    assert_broadcast("new_annotation", %{body: "2", at: 123})
  end
end

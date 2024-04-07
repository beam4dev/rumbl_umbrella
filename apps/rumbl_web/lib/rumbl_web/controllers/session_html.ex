defmodule RumblWeb.SessionHTML do
  use RumblWeb, :html

  def new(assigns) do
    ~H"""
      <.header>
        Loggin User
         <:subtitle>Use this form to manage users records in your database.</:subtitle>
      </.header>

       <.simple_form :let={f} for={@conn} action={~p"/sessions"}>
        <.input field={f[:username]} label="Username" />
        <.input type="password" field={f[:password]} label="Password" />

        <:actions>
          <.button>Login</.button>
        </:actions>

      </.simple_form>
    """
  end
end

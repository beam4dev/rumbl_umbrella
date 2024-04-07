defmodule RumblWeb.UserHTML do
  use RumblWeb, :html

  #alias Rumbl.Accounts

  #embed_templates "page_html/*"

  def index(assigns) do
    ~H"""

      <h2 class="text-2xl font-bold leading-7 text-gray-900 sm:truncate sm:text-3xl sm:tracking-tight">Listing of Users</h2>
      <div class="relative overflow-x-auto shadow-md sm:rounded-lg">
        <table  class="w-full text-sm text-left rtl:text-right text-gray-500 dark:text-gray-400">
        <thead class="text-xs text-gray-700 uppercase bg-gray-50 dark:bg-gray-700 dark:text-gray-400">
              <tr>
                  <th scope="col" class="px-6 py-3">
                      User name
                  </th>

                  <th scope="col" class="px-6 py-3">
                  </th>
              </tr>
          </thead>
          <tbody :for={user <- @users}>
              <tr class="odd:bg-white odd:dark:bg-gray-900 even:bg-gray-50 even:dark:bg-gray-800 border-b dark:border-gray-700">
                  <th scope="row" class="px-6 py-4 font-medium text-gray-900 whitespace-nowrap dark:text-white">
                  <b><%= user.name %></b> (<%= user.id %>)
                  </th>

                  <td class="px-6 py-5">
                    <.link href={~p"/users/#{user.id}"} class="font-medium text-blue-600 dark:text-blue-500 hover:underline">View</.link>
                  </td>
              </tr>
          </tbody>
       </table>
      </div>

    """
  end


  def show(assigns) do
    ~H"""
      <h2 class="text-2xl font-bold leading-7 text-gray-900 sm:truncate sm:text-3xl sm:tracking-tight">Showing User</h2>
      <div class="relative overflow-x-auto shadow-md sm:rounded-lg">
          <field><%=@user.name%></field>
          <field><%=@user.username%></field>
      </div>
      <.back navigate={~p"/users"}>Back to users</.back>
    """
  end

  def new(assigns) do
    ~H"""
    <.header>
        New User
         <:subtitle>Use this form to manage users records in your database.</:subtitle>
      </.header>
       <.simple_form :let={f} for={@changeset} action={~p"/users/"}>
        <.error :if={@changeset.action}>
           Oops, something went wrong! Please check the errors below.
        </.error>
        <.input field={f[:name]} label="Name"/>
        <.input field={f[:username]} label="Username" />
        <.input type="password" field={f[:password]} label="Password" />
        <:actions>
          <.button>Create User</.button>
        </:actions>
      </.simple_form>
    """
  end

end

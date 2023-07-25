defmodule DevFinderWeb.UserLive do
  use DevFinderWeb, :live_view

  require Logger

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:user_bio, default_user_bio())}
  end

  @impl true
  def handle_event("search", %{"user_bio" => %{"username" => username}}, socket) do
    IO.inspect(username, label: "[USERNAME]")

    case fetch_github_user(username) do
      {:ok, user_bio} ->
        {:nonreply, assign(socket, %{socket | user_bio: user_bio})}

      {:error, message} ->
        IO.inspect(message, label: "Error Message")

        {
          :noreply,
          assign(
            socket,
            %{socket | user_bio: default_user_bio()}
            |> tap(&IO.inspect(&1.assigns, label: "[SOCKET ASSIGNS]"))
          )
        }
    end

    {
      :noreply,
      socket
    }
  end

  defp default_user_bio do
    %{
      full_name: "James Rowa",
      avatar_url:
        "https://avatars.githubusercontent.com/u/76947107?s=400&u=cd0be7843d2c30ae6f985634ac9966b11242aacb&v=4",
      username: "rowah",
      profile_url: "https://github.com/rowah",
      bio:
        "Community-taught software developer, Biochemistry and teaching are my other professions. I am currently learning Elixir.",
      location: "Nairobi, Kenya",
      twitter_username: "@Jrowah",
      company: "Expivot",
      blog: "https://jrowah.com",
      created_at: "4 Jan 2021",
      profile_stats: %{
        public_repos: "44",
        followers: "17",
        following: "8"
      }
    }
  end
end

defmodule DevFinderWeb.UserLive.Index do
  use DevFinderWeb, :live_view

  import DevFinder.GithubApi

  require Logger

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :user_profile, default_user_profile())}
  end

  @impl true
  def handle_event("search", %{"user_profile" => %{"username" => username}} = _params, socket) do
    Logger.info("USERNAME: #{username}")
    dbg()

    case fetch_github_user(username) do
      {:ok, user_profile} ->
        {:noreply, socket |> assign(:user_profile, user_profile)}

      {:error, _reason} ->
        {:noreply,
         socket
         |> put_flash(:error, "Unexpected error. Please try again.")
         |> assign(:user_profile, default_user_profile())}

        # {:not_found, _reason} ->
        #   {:noreply,
        #    socket
        #    |> put_flash(:info, "Sorry. That user does not exist.")
        #    |> assign(:user_profile, default_user_profile())}
    end

    # {
    #   :noreply,
    #   socket
    # }
  end

  defp default_user_profile do
    Logger.info("default user bio loaded")

    %{
      name: "James Rowa",
      avatar_url:
        "https://avatars.githubusercontent.com/u/76947107?s=400&u=cd0be7843d2c30ae6f985634ac9966b11242aacb&v=4",
      username: "rowah",
      html_url: "https://github.com/rowah",
      bio:
        "Community-taught software developer, Biochemistry and teaching are my other professions. I am currently learning Elixir.",
      location: "Nairobi, Kenya",
      twitter_username: "@Jrowah",
      company: "Expivot",
      blog: "https://jrowah.com",
      created_at: "4 Feb 2021",
      public_repos: 43,
      followers: 17,
      following: 8
    }
  end
end

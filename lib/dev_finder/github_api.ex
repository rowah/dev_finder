defmodule DevFinder.GithubApi do
  require Logger

  @base_url "https://api.github.com"

  def fetch_github_user(username) do
    url = "#{@base_url}/users/#{username}"

    case HTTPoison.get(url) do
      {:ok, %HTTPoison.Response{status_code: 200, body: user_profile}} ->
        # Logs http responses. Response successful for valid users as user being logged here
        Logger.info("HTTPprofile: #{user_profile}", ansi_color: :blue)
        {:ok, user_profile}
        Logger.info("profile: #{user_profile}", ansi_color: :magenta)

        case Jason.decode(user_profile, keys: :atoms) do
          {:ok, user_profile} ->
            dbg()
            Logger.info("user_profile: #{inspect(user_profile)}", ansi_color: :magenta)
            IO.inspect(user_profile, label: "[DECODED PROFILE]")
            {:ok, user_profile}

          {:error, reason} ->
            Logger.info("error1: #{reason}")
            {:error, "JSON parsing error: #{reason}"}
        end

      {:ok, %HTTPoison.Response{status_code: code}} ->
        {:error, "Unexpected API response with status code: #{code}"}

      {:error, reason} ->
        {:error, "HTTP request error: #{reason}"}
    end
  end
end

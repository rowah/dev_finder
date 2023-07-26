defmodule DevFinder.GithubApi do
  require Logger

  @base_url "https://api.github.com"

  def fetch_github_user(username) do
    url = "#{@base_url}/users/#{username}"

    case HTTPoison.get(url) do
      {:ok, %HTTPoison.Response{status_code: 200, body: profile}} ->
        case Jason.decode(profile) do
          {:ok, profile} ->
            Logger.info("profile: #{profile}")
            {:ok, profile}

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

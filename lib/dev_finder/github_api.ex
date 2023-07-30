defmodule DevFinder.GithubApi do
  require Logger
  require Timex

  @base_url "https://api.github.com"
  @months ~w(Jan Feb Mar Apr May Jun Jul Aug Sept Oct Nov Dec)a

  def fetch_github_user(username) do
    url = "#{@base_url}/users/#{username}"

    case HTTPoison.get(url) do
      {:ok, %HTTPoison.Response{status_code: 200, body: data}} ->
        # Logs http responses. Response successful for valid users as user being logged here
        Logger.info("HTTPprofile: #{data}", ansi_color: :blue)
        {:ok, data}
        Logger.info("profile: #{data}", ansi_color: :magenta)

        case Jason.decode(data, keys: :atoms) do
          {:ok, data} ->
            user_profile =
              data
              |> Map.put(:username, data[:login])
              # |> Map.delete(:login)
              |> Map.put(:created_at, format_date(data[:created_at]))

            # dbg()
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

  defp format_date(date) do
    {:ok, date} = Timex.parse(date, "{ISO:Extended}")
    {:ok, formatted_date} = Timex.format(date, "{D} {M} {YYYY}")
    [day, month, year] = String.split(formatted_date, " ") |> Enum.map(&String.to_integer/1)

    month_name = @months |> Enum.at(month)

    formatted_date = "#{day} #{month_name} #{year}"
    formatted_date
  end
end

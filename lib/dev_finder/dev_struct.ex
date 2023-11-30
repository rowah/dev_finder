defmodule DevFinder.DevStruct do
  defstruct name: "",
            avatar_url: "",
            username: "",
            html_url: "",
            bio: "",
            location: "",
            twitter_username: "",
            company: "",
            blog: "",
            created_at: "",
            public_repos: nil,
            followers: nil,
            following: nil

  alias DevFinder.DevStruct

  @type t :: %DevStruct{
          name: String.t(),
          avatar_url: String.t() | nil,
          username: String.t(),
          html_url: String.t(),
          bio: String.t(),
          location: String.t(),
          twitter_username: String.t() | nil,
          company: String.t(),
          blog: String.t(),
          created_at: Date.t(),
          public_repos: number(),
          followers: number(),
          following: number()
        }
end

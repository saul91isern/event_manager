# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :event_manager,
  ecto_repos: [EventManager.Repo]

# Configures the endpoint
config :event_manager, EventManagerWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "UQDPbN5sJhgmzMgR5K1JR7G+ILrAyq4JwymupLZUjH3Ps3SYpRYb7lk4adiNdi8R",
  render_errors: [view: EventManagerWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: EventManager.PubSub, adapter: Phoenix.PubSub.PG2],
  live_view: [signing_salt: "aXEt5d7r"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"

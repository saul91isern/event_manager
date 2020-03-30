defmodule EventManagerWeb.Router do
  use EventManagerWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", EventManagerWeb do
    pipe_through :api

    resources("/events", EventController, only: [:index])
  end
end

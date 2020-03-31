defmodule EventManager.Events do
  @moduledoc """
  The Events context.
  """

  import Ecto.Query, warn: false
  alias EventManager.Repo

  alias EventManager.Events.Base

  def load([]), do: {:ok, []}

  def load(base_events) do
    Repo.transaction(fn ->
      with {true, bases} <- load_base_events(base_events),
           {true, events} <- load_events(bases),
           {true, _} <- load_zones(events) do
        bases
      else
        _ -> Repo.rollback({:error, %{error: :failed_upload}})
      end
    end)
  end

  defp load_base_events(base_events) do
    bases = Enum.map(base_events, &load_base_event/1)
    {Enum.all?(bases, &(elem(&1, 0) == :ok)), bases}
  end

  defp load_events(events) do
    events =
      events
      |> Enum.map(&Map.put(elem(&1, 2), "base", elem(&1, 1)))
      |> Enum.map(&load_event/1)

    {Enum.all?(events, &(elem(&1, 0) == :ok)), events}
  end

  defp load_zones(events) do
    zones =
      events
      |> Enum.map(fn {_, event, zones} ->
        event_id = Map.get(event, :id)
        put_id(event_id, zones)
      end)
      |> List.flatten()
      |> Enum.map(&load_zone/1)

    {Enum.all?(events, &(elem(&1, 0) == :ok)), zones}
  end

  defp load_base_event(%{"#content" => %{"event" => event}} = base) do
    external_id = Map.get(base, "-base_event_id")
    sell_mode = Map.get(base, "-sell_mode")
    title = Map.get(base, "-title")

    external_id
    |> get_base_by()
    |> case do
      nil ->
        attrs = %{external_id: external_id, title: title, sell_mode: sell_mode}

        Tuple.append(
          create_base(attrs),
          event
        )

      base ->
        {:ok, base, event}
    end
  end

  defp load_event(%{"#content" => %{"zone" => zones}, "base" => base} = event) do
    event_date = Map.get(event, "-event_date")
    external_id = Map.get(event, "-event_id")
    sell_from = Map.get(event, "-sell_from")
    sold_out = Map.get(event, "-sold_out")
    sell_to = Map.get(event, "-sell_to")
    base_id = Map.get(base, :id)

    attrs = %{
      external_id: external_id,
      event_date: event_date,
      sell_from: sell_from,
      sold_out: sold_out,
      sell_to: sell_to,
      base_id: base_id
    }

    Tuple.append(
      create_event(attrs),
      zones
    )
  end

  defp load_zone(zone) do
    capacity = Map.get(zone, "-capacity")
    max_price = Map.get(zone, "-max_price")
    name = Map.get(zone, "-name")
    numbered = Map.get(zone, "-numbered")
    external_id = Map.get(zone, "-zone_id")
    event_id = Map.get(zone, "event_id")

    attrs = %{
      capacity: capacity,
      name: name,
      max_price: max_price,
      numbered: numbered,
      external_id: external_id,
      event_id: event_id
    }

    create_zone(attrs)
  end

  defp put_id(event_id, %{} = zone), do: [Map.put(zone, "event_id", event_id)]

  defp put_id(event_id, zones) when is_list(zones),
    do: Enum.map(zones, &Map.put(&1, "event_id", event_id))

  @doc """
  Returns the list of bases.

  ## Examples

      iex> list_bases()
      [%Base{}, ...]

  """
  def list_bases do
    Repo.all(Base)
  end

  @doc """
  Gets a single base by external id.

  ## Examples

      iex> get_base_by(123)
      %Base{}

      iex> get_base_by(456)
      ** nil

  """
  def get_base_by(external_id), do: Repo.get_by(Base, external_id: external_id)

  @doc """
  Creates a base.

  ## Examples

      iex> create_base(%{field: value})
      {:ok, %Base{}}

      iex> create_base(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_base(attrs \\ %{}) do
    %Base{}
    |> Base.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking base changes.

  ## Examples

      iex> change_base(base)
      %Ecto.Changeset{source: %Base{}}

  """
  def change_base(%Base{} = base) do
    Base.changeset(base, %{})
  end

  alias EventManager.Events.Event

  @doc """
  Returns the list of events.

  ## Examples

      iex> list_events()
      [%Event{}, ...]

  """
  def list_events(attrs \\ %{}) do
    dynamic = true
    dynamic = build_from(attrs, dynamic)
    dynamic = build_to(attrs, dynamic)

    Event
    |> join(:inner, [e, be], be in "bases", on: be.id == e.base_id)
    |> where(^dynamic)
    |> where([_e, be], be.sell_mode == "online")
    |> select([e, _], e)
    |> Repo.all()
    |> Repo.preload([:base, :zones])
  end

  defp build_from(%{"start_date" => start_date}, dynamic) when not is_nil(start_date) do
    dynamic([e, _be], field(e, :event_date) >= ^start_date and ^dynamic)
  end

  defp build_from(_, dynamic), do: dynamic

  defp build_to(%{"end_date" => end_date}, dynamic) when not is_nil(end_date) do
    dynamic([e, _be], field(e, :event_date) <= ^end_date and ^dynamic)
  end

  defp build_to(_, dynamic), do: dynamic

  @doc """
  Creates a event.

  ## Examples

      iex> create_event(%{field: value})
      {:ok, %Event{}}

      iex> create_event(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_event(attrs \\ %{}) do
    %Event{}
    |> Event.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking event changes.

  ## Examples

      iex> change_event(event)
      %Ecto.Changeset{source: %Event{}}

  """
  def change_event(%Event{} = event) do
    Event.changeset(event, %{})
  end

  alias EventManager.Events.Zone

  @doc """
  Returns the list of zones.

  ## Examples

      iex> list_zones()
      [%Zone{}, ...]

  """
  def list_zones do
    Repo.all(Zone)
  end

  @doc """
  Creates a zone.

  ## Examples

      iex> create_zone(%{field: value})
      {:ok, %Zone{}}

      iex> create_zone(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_zone(attrs \\ %{}) do
    %Zone{}
    |> Zone.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking zone changes.

  ## Examples

      iex> change_zone(zone)
      %Ecto.Changeset{source: %Zone{}}

  """
  def change_zone(%Zone{} = zone) do
    Zone.changeset(zone, %{})
  end
end

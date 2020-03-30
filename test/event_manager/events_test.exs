defmodule EventManager.EventsTest do
  use EventManager.DataCase

  alias EventManager.Events

  describe "bases" do
    alias EventManager.Events.Base

    @valid_attrs %{external_id: "some external_id", sell_mode: "some sell_mode", title: "some title"}
    @update_attrs %{external_id: "some updated external_id", sell_mode: "some updated sell_mode", title: "some updated title"}
    @invalid_attrs %{external_id: nil, sell_mode: nil, title: nil}

    def base_fixture(attrs \\ %{}) do
      {:ok, base} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Events.create_base()

      base
    end

    test "list_bases/0 returns all bases" do
      base = base_fixture()
      assert Events.list_bases() == [base]
    end

    test "get_base!/1 returns the base with given id" do
      base = base_fixture()
      assert Events.get_base!(base.id) == base
    end

    test "create_base/1 with valid data creates a base" do
      assert {:ok, %Base{} = base} = Events.create_base(@valid_attrs)
      assert base.external_id == "some external_id"
      assert base.sell_mode == "some sell_mode"
      assert base.title == "some title"
    end

    test "create_base/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Events.create_base(@invalid_attrs)
    end

    test "update_base/2 with valid data updates the base" do
      base = base_fixture()
      assert {:ok, %Base{} = base} = Events.update_base(base, @update_attrs)
      assert base.external_id == "some updated external_id"
      assert base.sell_mode == "some updated sell_mode"
      assert base.title == "some updated title"
    end

    test "update_base/2 with invalid data returns error changeset" do
      base = base_fixture()
      assert {:error, %Ecto.Changeset{}} = Events.update_base(base, @invalid_attrs)
      assert base == Events.get_base!(base.id)
    end

    test "delete_base/1 deletes the base" do
      base = base_fixture()
      assert {:ok, %Base{}} = Events.delete_base(base)
      assert_raise Ecto.NoResultsError, fn -> Events.get_base!(base.id) end
    end

    test "change_base/1 returns a base changeset" do
      base = base_fixture()
      assert %Ecto.Changeset{} = Events.change_base(base)
    end
  end

  describe "events" do
    alias EventManager.Events.Event

    @valid_attrs %{event_date: "2010-04-17T14:00:00.000000Z", external_id: "some external_id", sell_from: "2010-04-17T14:00:00.000000Z", sell_to: "2010-04-17T14:00:00.000000Z", sold_out: true}
    @update_attrs %{event_date: "2011-05-18T15:01:01.000000Z", external_id: "some updated external_id", sell_from: "2010-04-17T14:00:00.000000Z", sell_to: "2011-05-18T15:01:01.000000Z", sold_out: false}
    @invalid_attrs %{event_date: nil, external_id: nil, sell_from: nil, sell_to: nil, sold_out: nil}

    def event_fixture(attrs \\ %{}) do
      {:ok, event} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Events.create_event()

      event
    end

    test "list_events/0 returns all events" do
      event = event_fixture()
      assert Events.list_events() == [event]
    end

    test "get_event!/1 returns the event with given id" do
      event = event_fixture()
      assert Events.get_event!(event.id) == event
    end

    test "create_event/1 with valid data creates a event" do
      assert {:ok, %Event{} = event} = Events.create_event(@valid_attrs)
      assert event.event_date == DateTime.from_naive!(~N[2010-04-17T14:00:00.000000Z], "Etc/UTC")
      assert event.external_id == "some external_id"
      assert event.sell_from == DateTime.from_naive!(~N[2010-04-17T14:00:00.000000Z], "Etc/UTC")
      assert event.sell_to == DateTime.from_naive!(~N[2010-04-17T14:00:00.000000Z], "Etc/UTC")
      assert event.sold_out == true
    end

    test "create_event/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Events.create_event(@invalid_attrs)
    end

    test "update_event/2 with valid data updates the event" do
      event = event_fixture()
      assert {:ok, %Event{} = event} = Events.update_event(event, @update_attrs)
      assert event.event_date == DateTime.from_naive!(~N[2011-05-18T15:01:01.000000Z], "Etc/UTC")
      assert event.external_id == "some updated external_id"
      assert event.sell_from == DateTime.from_naive!(~N[2011-05-18T15:01:01.000000Z], "Etc/UTC")
      assert event.sell_to == DateTime.from_naive!(~N[2011-05-18T15:01:01.000000Z], "Etc/UTC")
      assert event.sold_out == false
    end

    test "update_event/2 with invalid data returns error changeset" do
      event = event_fixture()
      assert {:error, %Ecto.Changeset{}} = Events.update_event(event, @invalid_attrs)
      assert event == Events.get_event!(event.id)
    end

    test "delete_event/1 deletes the event" do
      event = event_fixture()
      assert {:ok, %Event{}} = Events.delete_event(event)
      assert_raise Ecto.NoResultsError, fn -> Events.get_event!(event.id) end
    end

    test "change_event/1 returns a event changeset" do
      event = event_fixture()
      assert %Ecto.Changeset{} = Events.change_event(event)
    end
  end

  describe "zones" do
    alias EventManager.Events.Zone

    @valid_attrs %{capacity: "some capacity", external_id: "some external_id", max_price: 120.5, name: "some name", numbered: true}
    @update_attrs %{capacity: "some updated capacity", external_id: "some updated external_id", max_price: 456.7, name: "some updated name", numbered: false}
    @invalid_attrs %{capacity: nil, external_id: nil, max_price: nil, name: nil, numbered: nil}

    def zone_fixture(attrs \\ %{}) do
      {:ok, zone} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Events.create_zone()

      zone
    end

    test "list_zones/0 returns all zones" do
      zone = zone_fixture()
      assert Events.list_zones() == [zone]
    end

    test "get_zone!/1 returns the zone with given id" do
      zone = zone_fixture()
      assert Events.get_zone!(zone.id) == zone
    end

    test "create_zone/1 with valid data creates a zone" do
      assert {:ok, %Zone{} = zone} = Events.create_zone(@valid_attrs)
      assert zone.capacity == "some capacity"
      assert zone.external_id == "some external_id"
      assert zone.max_price == 120.5
      assert zone.name == "some name"
      assert zone.numbered == true
    end

    test "create_zone/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Events.create_zone(@invalid_attrs)
    end

    test "update_zone/2 with valid data updates the zone" do
      zone = zone_fixture()
      assert {:ok, %Zone{} = zone} = Events.update_zone(zone, @update_attrs)
      assert zone.capacity == "some updated capacity"
      assert zone.external_id == "some updated external_id"
      assert zone.max_price == 456.7
      assert zone.name == "some updated name"
      assert zone.numbered == false
    end

    test "update_zone/2 with invalid data returns error changeset" do
      zone = zone_fixture()
      assert {:error, %Ecto.Changeset{}} = Events.update_zone(zone, @invalid_attrs)
      assert zone == Events.get_zone!(zone.id)
    end

    test "delete_zone/1 deletes the zone" do
      zone = zone_fixture()
      assert {:ok, %Zone{}} = Events.delete_zone(zone)
      assert_raise Ecto.NoResultsError, fn -> Events.get_zone!(zone.id) end
    end

    test "change_zone/1 returns a zone changeset" do
      zone = zone_fixture()
      assert %Ecto.Changeset{} = Events.change_zone(zone)
    end
  end
end

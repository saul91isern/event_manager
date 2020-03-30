defmodule EventManagerWeb.EventControllerTest do
  use EventManagerWeb.ConnCase

  alias EventManager.Events
  alias EventManager.Events.Event

  @create_attrs %{
    event_date: "2010-04-17T14:00:00.000000Z",
    external_id: "some external_id",
    sell_from: "2010-04-17T14:00:00.000000Z",
    sell_to: "2010-04-17T14:00:00.000000Z",
    sold_out: true
  }
  @update_attrs %{
    event_date: "2011-05-18T15:01:01.000000Z",
    external_id: "some updated external_id",
    sell_from: "2010-04-17T14:00:00.000000Z",
    sell_to: "2011-05-18T15:01:01.000000Z",
    sold_out: false
  }
  @invalid_attrs %{event_date: nil, external_id: nil, sell_from: nil, sell_to: nil, sold_out: nil}

  def fixture(:event) do
    {:ok, event} = Events.create_event(@create_attrs)
    event
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all events", %{conn: conn} do
      conn = get(conn, Routes.event_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create event" do
    test "renders event when data is valid", %{conn: conn} do
      conn = post(conn, Routes.event_path(conn, :create), event: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.event_path(conn, :show, id))

      assert %{
               "id" => id,
               "event_date" => "2010-04-17T14:00:00.000000Z",
               "external_id" => "some external_id",
               "sell_from" => "2010-04-17T14:00:00.000000Z",
               "sell_to" => "2010-04-17T14:00:00.000000Z",
               "sold_out" => true
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.event_path(conn, :create), event: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update event" do
    setup [:create_event]

    test "renders event when data is valid", %{conn: conn, event: %Event{id: id} = event} do
      conn = put(conn, Routes.event_path(conn, :update, event), event: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.event_path(conn, :show, id))

      assert %{
               "id" => id,
               "event_date" => "2011-05-18T15:01:01.000000Z",
               "external_id" => "some updated external_id",
               "sell_from" => "2011-05-18T15:01:01.000000Z",
               "sell_to" => "2011-05-18T15:01:01.000000Z",
               "sold_out" => false
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, event: event} do
      conn = put(conn, Routes.event_path(conn, :update, event), event: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete event" do
    setup [:create_event]

    test "deletes chosen event", %{conn: conn, event: event} do
      conn = delete(conn, Routes.event_path(conn, :delete, event))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.event_path(conn, :show, event))
      end
    end
  end

  defp create_event(_) do
    event = fixture(:event)
    {:ok, event: event}
  end
end

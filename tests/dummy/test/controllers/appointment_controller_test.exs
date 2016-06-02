defmodule Dummy.AppointmentControllerTest do
  use Dummy.ConnCase
  import Dummy.SeedSupport

  setup do
    appointment = build_appointment
    import_batch = build_import_batch(appointment)
    export_batch = build_export_batch(appointment)
    {:ok, appointment: appointment, import_batch: import_batch, export_batch: export_batch}
  end

  test "it should show appointment", %{conn: conn, appointment: appointment} do
    path = conn |> appointment_path(:show, appointment.id)
    assert path == "/api/appointments/#{appointment.id}"

    assert %{"data" => data, "meta" => _meta} = conn
    |> get(path, %{})
    |> json_response(200)

    assert data["type"] == "appointments"
    assert data["id"] == appointment.id
  end

  test "it should index appointments", %{conn: conn, appointment: %{id: id}} do
    path = conn |> appointment_path(:index)
    assert %{"data" => data, "meta" => meta} = conn |> get(path, %{}) |> json_response(200)

    assert meta["count"] == 1
    assert [%{"id" => ^id, "type" => "appointments"}] = data
  end

  test "it should handle polymorphic relationships correctly", %{conn: conn, appointment: %{id: id}, import_batch: batch} do
    path = conn |> appointment_import_batch_relationship_path(:index, id)
    assert path == "/api/appointments/#{id}/import-batches"
    assert %{"data" => data, "meta" => meta} = conn
    |> get(path, %{})
    |> json_response(200)

    assert meta["count"] == 1
    assert [batch_json] = data
    assert batch_json["id"] == batch.id
    assert batch_json["type"] == "batches"
  end
end

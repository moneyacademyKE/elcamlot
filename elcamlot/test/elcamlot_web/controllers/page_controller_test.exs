defmodule ElcamlotWeb.PageControllerTest do
  use ElcamlotWeb.ConnCase

  setup :register_and_log_in_user

  test "GET /", %{conn: conn} do
    conn = get(conn, ~p"/")
    assert html_response(conn, 200) =~ "Search the Web"
  end
end

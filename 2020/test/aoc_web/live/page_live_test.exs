defmodule AocWeb.PageLiveTest do
  use AocWeb.ConnCase

  import Phoenix.LiveViewTest

  test "disconnected and connected render", %{conn: conn} do
    {:ok, page_live, disconnected_html} = live(conn, "/")
    assert disconnected_html =~ "Advent of Code"
    assert render(page_live) =~ "Advent of Code"
  end
end

defmodule Multex.TenantIdFromHeaderPlugTest do
    use ExUnit.Case, async: true
    use Multex.ConnCase

    @default_opts Multex.Plugs.TenantIdFromHeader.init([])
    @other_config Multex.Plugs.TenantIdFromHeader.init(header: "foo")
    @uuid_config Multex.Plugs.TenantIdFromHeader.init(header: "tenant_uuid")

    test "raises error if no header" do
      conn = conn(:get, "/hello")

      conn = Multex.Plugs.TenantIdFromHeader.call(conn, @default_opts)

      assert conn.state == :sent
      assert conn.status == 404
      assert conn.resp_body == "Not Found!"

    end

    test "reads default header when set" do
      conn = conn(:get, "/hello") |> Plug.Conn.put_req_header("tenant_id", "baz")

      conn = Multex.Plugs.TenantIdFromHeader.call(conn, @default_opts)

      assert conn.assigns.tenant_id == "baz"

    end

    test "does not read default header when configured to something else" do
      conn = conn(:get, "/hello") |> Plug.Conn.put_req_header("tenant_id", "bar")

      conn = Multex.Plugs.TenantIdFromHeader.call(conn, @other_config)

      assert conn.state == :sent
      assert conn.status == 404
      assert conn.resp_body == "Not Found!"

    end

    test "reads other headers when alternate header configured" do
      conn = conn(:get, "/hello") |> Plug.Conn.put_req_header("foo", "bar")

      conn = Multex.Plugs.TenantIdFromHeader.call(conn, @other_config)

      assert conn.assigns.tenant_id == "bar"
    end

    test "specifically test tenant_uuid case" do
      conn = conn(:get, "/hello") |> Plug.Conn.put_req_header("tenant_uuid", "abc")

      conn = Multex.Plugs.TenantIdFromHeader.call(conn, @uuid_config)

      assert conn.assigns.tenant_id == "abc"
    end

end
defmodule Multitenancy.IntegratedPlugTest do
    use ExUnit.Case, async: true
    use Multitenancy.ConnCase

    def deterministic_lookup(_id) do
      "5"
    end

    def function_lookup(id) do
      "tenant_" <> id
    end

    @default_id_opts Multitenancy.Plugs.TenantIdFromHeader.init([])
    @other_id_config Multitenancy.Plugs.TenantIdFromHeader.init(header: "foo")
    @uuid_id_config Multitenancy.Plugs.TenantIdFromHeader.init(header: "tenant_uuid")

    @default_schema_opts Multitenancy.Plugs.TenantSchemaFromId.init([])
    @other_schema_config Multitenancy.Plugs.TenantSchemaFromId.init(lookup: &Multitenancy.IntegratedPlugTest.deterministic_lookup/1)
    @function_schema_config Multitenancy.Plugs.TenantSchemaFromId.init(lookup: &Multitenancy.IntegratedPlugTest.function_lookup/1)

    test "chain plugs using default configs" do
      conn = conn(:get, "/hello") |> Plug.Conn.put_req_header("tenant_id", "baz")

      conn = Multitenancy.Plugs.TenantIdFromHeader.call(conn, @default_id_opts)
      conn = Multitenancy.Plugs.TenantSchemaFromId.call(conn, @default_schema_opts)

      assert conn.assigns.tenant_id == "baz"
      assert conn.assigns.tenant_schema == "schema_baz"
    end

    test "chain plugs using other configs" do
      conn = conn(:get, "/hello") |> Plug.Conn.put_req_header("foo", "bar")

      conn = Multitenancy.Plugs.TenantIdFromHeader.call(conn, @other_id_config)
      conn = Multitenancy.Plugs.TenantSchemaFromId.call(conn, @other_schema_config)

      assert conn.assigns.tenant_id == "bar"
      assert conn.assigns.tenant_schema == "5"
    end

    test "specifically test tenant_uuid case" do

      conn = conn(:get, "/hello") |> Plug.Conn.put_req_header("tenant_uuid", "4c3c0rp")

      conn = Multitenancy.Plugs.TenantIdFromHeader.call(conn, @uuid_id_config)
      conn = Multitenancy.Plugs.TenantSchemaFromId.call(conn, @function_schema_config)

      assert conn.assigns.tenant_schema == "tenant_4c3c0rp"
    end

end
defmodule Multex.TenantSchemaFromIdPlugTest do
    use ExUnit.Case, async: true
    use Multex.ConnCase

    def deterministic_lookup(_id) do
      "4"
    end

    def function_lookup(id) do
      "customer_" <> id
    end

    @default_opts Multex.Plugs.TenantSchemaFromId.init([])
    @other_config Multex.Plugs.TenantSchemaFromId.init(lookup: &Multex.TenantSchemaFromIdPlugTest.deterministic_lookup/1)
    @function_config Multex.Plugs.TenantSchemaFromId.init(lookup: &Multex.TenantSchemaFromIdPlugTest.function_lookup/1)

    test "raises error if no assign" do
      conn = conn(:get, "/hello")

      #@TODO have a better error case here?
      assert_raise(KeyError, fn ->
        _conn = Multex.Plugs.TenantSchemaFromId.call(conn, @default_opts)
      end)

    end

    test "generates default schema pattern when set" do
      conn = conn(:get, "/hello") |> Plug.Conn.assign(:tenant_id, "foo")

      conn = Multex.Plugs.TenantSchemaFromId.call(conn, @default_opts)

      assert conn.assigns.tenant_schema == "schema_foo"

    end

    test "computes other schemas when alternate lookup configured" do
      conn = conn(:get, "/hello") |> Plug.Conn.assign(:tenant_id, "foo")

      conn = Multex.Plugs.TenantSchemaFromId.call(conn, @other_config)

      assert conn.assigns.tenant_schema == "4"
    end

    test "specifically test tenant_uuid case" do
      conn = conn(:get, "/hello") |> Plug.Conn.assign(:tenant_id, "abc")

      conn = Multex.Plugs.TenantSchemaFromId.call(conn, @function_config)

      assert conn.assigns.tenant_schema == "customer_abc"
    end

end
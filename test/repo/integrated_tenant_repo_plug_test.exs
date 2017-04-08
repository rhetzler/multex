# the defaults provided by Multex.TenantRepo should make it
# compatible out-of-the-box with the Tenant-Schema-From-Id-From-Header plug chain
defmodule IntegratedTenantRepoPlugTest.TenantRepoDefaults do
  use Multex.TenantRepo,
    repo: StubRepo
end

defmodule IntegratedTenantRepoPlugTest do
    use ExUnit.Case, async: true
    use Multex.ConnCase

    require IntegratedTenantRepoPlugTest.TenantRepoDefaults
    alias IntegratedTenantRepoPlugTest.TenantRepoDefaults

    def function_lookup(id) do
      "prefix_" <> id <> "_suffix"
    end

    @default_id_opts Multex.Plugs.TenantIdFromHeader.init([])
    @uuid_id_config Multex.Plugs.TenantIdFromHeader.init(header: "tenant_uuid")

    @default_schema_opts Multex.Plugs.TenantSchemaFromId.init([])
    @function_schema_config Multex.Plugs.TenantSchemaFromId.init(lookup: &IntegratedTenantRepoPlugTest.function_lookup/1)


    # validate queryable based functionality
    test "default_happy_path" do

      conn = conn(:get, "/hello") |> Plug.Conn.put_req_header("tenant_id", "baz")
        |> Multex.Plugs.TenantIdFromHeader.call(@default_id_opts)
        |> Multex.Plugs.TenantSchemaFromId.call(@default_schema_opts)

      _result = TenantRepoDefaults.all( TestModel )

      assert_receive %{method: :all, queryable: ( %Ecto.Query{} = query ), opts: _ }
      assert query |> Map.get(:prefix) == "schema_baz"

    end

    # validate queryable based functionality
    test "customized_plugs_path" do

      conn = conn(:get, "/hello") |> Plug.Conn.put_req_header("tenant_uuid", "sarsaparilla")
        |> Multex.Plugs.TenantIdFromHeader.call(@uuid_id_config)
        |> Multex.Plugs.TenantSchemaFromId.call(@function_schema_config)

      _result = TenantRepoDefaults.all( TestModel )

      assert_receive %{method: :all, queryable: ( %Ecto.Query{} = query ), opts: _ }
      assert query |> Map.get(:prefix) == "prefix_sarsaparilla_suffix"

    end


end
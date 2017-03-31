defmodule MultiTenancy.Plugs.TenantSchemaFromId do
  @moduledoc """
  A plug for extracting the tenant schema from an id

  We assume tenant_id has been set to a conn.assigns upstream in the plug pipeline (see tenant_id_from_header)
   - feel free to determine the identifier via other means and place it into conn.assigns.tenant_id for reuse here

  By default, this will prepend "schema_" to the identifier, however this can be configured with a function call
    to generate the schema name for you.

  def prepend_tenant(id) do "tenant_" <> id end

  plug Multitenancy.Plugs.TenantSchemaFromId, lookup: &MyModule.prepend_tenant/1

  - if there is a way to make this work with anonymous functions, please let me know
  """
  import Plug.Conn

  def prepend_schema(id) do
    "schema_" <> id
  end

  def init(opts) do
    lookup = Keyword.get(opts, :lookup) || &MultiTenancy.Plugs.TenantSchemaFromId.prepend_schema/1
    opts |> Keyword.put(:lookup, lookup)
  end

  def call(conn, options) do
    conn |> assign(:tenant_schema, Keyword.fetch!(options, :lookup).(conn.assigns.tenant_id))
  end

end
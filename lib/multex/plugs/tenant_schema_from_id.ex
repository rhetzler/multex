defmodule Multex.Plugs.TenantSchemaFromId do
  @moduledoc """
    A plug for transforming a tenant identifier to a schema name

    We assume tenant_id has been set to a conn.assigns upstream in the plug pipeline (see Multex.Plugs.TenantIdFromHeader)

    This can be supplied by other modules, the interface only assumes that conn.assigns.tenant_id is populated correctly

    By default, this plug will prepend "schema_" to the identifier, however this can be configured with a function call
    to generate the schema name for you as follows:

      def prepend_tenant(id) do "tenant_" <> id end

      plug Multex.Plugs.TenantSchemaFromId, lookup: &MyModule.prepend_tenant/1

    The main reason for this paramterization is to allow you to do more dynamic lookups, ie, if you track tenancy via database:

      def tenant_from_database(id) do Repo.get!(Tenant, id).schema end

      plug Multex.Plugs.TenantSchemaFromId, lookup: &MyModule.tenant_from_database/1

    - if there is a way to make this work with anonymous functions, please let me know
  """
  import Plug.Conn

  def prepend_schema(id) do
    "schema_" <> id
  end

  def init(opts) do
    lookup = Keyword.get(opts, :lookup) || &Multex.Plugs.TenantSchemaFromId.prepend_schema/1
    opts |> Keyword.put(:lookup, lookup)
  end

  def call(conn, options) do
    conn |> assign(:tenant_schema, Keyword.fetch!(options, :lookup).(conn.assigns.tenant_id))
  end

end
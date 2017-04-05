defmodule Multex.Plugs.TenantIdFromHeader do
  @moduledoc """
    A plug for extracting a tenant identifier from an http header

    By default the header TENANT_ID is expected, however this can be configured:

    plug Multex.Plugs.TenantIdFromHeader, header: "tenant_uuid"
    note: the parser will only accept lower-case header specifications, even if the header is sent uppercase

    The identifier is then placed into a connection assigns "tenant_id" for use downstream (see TenantSchemaFromId)
  """
  import Plug.Conn

  def init(opts) do
    header = Keyword.get(opts, :header) || "tenant_id"

    opts |> Keyword.put(:header, header)
  end

  def call(conn, options) do
    case get_req_header(conn, Keyword.fetch!(options, :header)) do
      [] -> conn |> send_resp(404, "Not Found!")
      [tenant_id] -> conn |> assign(:tenant_id, tenant_id)
    end
  end

end
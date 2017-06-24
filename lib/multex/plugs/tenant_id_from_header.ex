defmodule Multex.Plugs.TenantIdFromHeader do
  @moduledoc """
    A plug for extracting a tenant identifier from an http header

    By default the header TENANT_ID is expected, however this can be configured:

    plug Multex.Plugs.TenantIdFromHeader, header: "tenant_uuid"
    note: the parser will only accept lower-case header specifications, even if the header is sent uppercase

    The identifier is then placed into a connection assigns "tenant_id" for use downstream (see TenantSchemaFromId)
  """
  import Plug.Conn
  require Logger

  def init(opts) do
    header = Keyword.get(opts, :header) || "tenant_id"

    opts |> Keyword.put(:header, header)
  end

  def call(conn, options) do
    header = Keyword.fetch!(options, :header)
    case get_req_header(conn, header) do
      [] ->
        Logger.info("[MULTEX] Received Request without '#{header}' header, returning 404'")
        conn
        |> send_resp(404, "Not Found!")
        |> halt
      [tenant_id] ->
        Logger.info("[MULTEX] Received request with '#{header}' header set to '#{tenant_id}'")
        conn |> assign(:tenant_id, tenant_id)
    end
  end

end
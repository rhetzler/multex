defmodule StubRepo do
  @behaviour Ecto.Repo

  def get(queryable, id, opts) do
    send self(), %{method: :get, queryable: queryable, id: id, opts: opts}
  end
  def get!(queryable, id, opts) do
    send self(), %{method: :get!, queryable: queryable, id: id, opts: opts}
  end
  def get_by(queryable, clauses, opts) do
    send self(), %{method: :get_by, queryable: queryable, clauses: clauses, opts: opts}
  end
  def get_by!(queryable, clauses, opts) do
    send self(), %{method: :get_by!, queryable: queryable, clauses: clauses, opts: opts}
  end
  def aggregate(queryable, aggregate, field, opts) do
    send self(), %{method: :aggregate, queryable: queryable, aggregate: aggregate, field: field, opts: opts}
  end
  def one(queryable, opts) do
    send self(), %{method: :one, queryable: queryable, opts: opts}
  end
  def one!(queryable, opts) do
    send self(), %{method: :one!, queryable: queryable, opts: opts}
  end
  def preload(struct_or_structs, preloads, opts) do
    send self(), %{method: :preload, struct_or_structs: struct_or_structs, preloads: preloads, opts: opts}
  end
  def all(queryable, opts) do
    send self(), %{method: :all, queryable: queryable, opts: opts}
  end
  def insert_all(schema_or_source, entries, opts) do
    send self(), %{method: :insert_all, schema_or_source: schema_or_source, entries: entries, opts: opts}
  end
  def update_all(queryable, updates, opts) do
    send self(), %{method: :update_all, queryable: queryable, updates: updates, opts: opts}
  end
  def delete_all(queryable, opts) do
    send self(), %{method: :delete_all, queryable: queryable, opts: opts}
  end
  def insert(struct_or_changeset, opts) do
    send self(), %{method: :insert, struct_or_changeset: struct_or_changeset, opts: opts}
  end
  def update(changeset, opts) do
    send self(), %{method: :update, changeset: changeset, opts: opts}
  end
  def insert_or_update(changeset, opts) do
    send self(), %{method: :insert_or_update, changeset: changeset, opts: opts}
  end
  def delete(struct_or_changeset, opts) do
    send self(), %{method: :delete, struct_or_changeset: struct_or_changeset, opts: opts}
  end
  def insert!(struct_or_changeset, opts) do
    send self(), %{method: :insert!, struct_or_changeset: struct_or_changeset, opts: opts}
  end
  def update!(changeset, opts) do
    send self(), %{method: :update!, changeset: changeset, opts: opts}
  end
  def insert_or_update!(changeset, opts) do
    send self(), %{method: :insert_or_update!, changeset: changeset, opts: opts}
  end
  def delete!(struct_or_changeset, opts) do
    send self(), %{method: :delete!, struct_or_changeset: struct_or_changeset, opts: opts}
  end

  def __adapter__ do
    send self(), %{method: :__adapter__}
  end
  def __log__(entry) do
    send self(), %{method: :__log__, entry: entry}
  end
  def config() do
    send self(), %{method: :config}
  end
  def start_link(opts) do
    send self(), %{method: :start_link, opts: opts}
  end
  def stop(pid, timeout) do
    send self(), %{method: :stop, pid: pid, timeout: timeout}
  end
  def transaction(fun_or_multi, opts) do
    send self(), %{method: :transaction, fun_or_multi: fun_or_multi, opts: opts}
  end
  def in_transaction?() do
    send self(), %{method: :in_transaction}
  end
  def  rollback(value) do
    send self(), %{method: :rollback, value: value}
  end
end
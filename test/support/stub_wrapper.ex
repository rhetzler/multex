defmodule StubWrapper do
  @behaviour Ecto.Repo

  def get(var, queryable, id, opts) do
    send self(), %{method: :get, var: var, queryable: queryable, id: id, opts: opts}
  end
  def get!(var, queryable, id, opts) do
    send self(), %{method: :get!, var: var, queryable: queryable, id: id, opts: opts}
  end
  def get_by(var, queryable, clauses, opts) do
    send self(), %{method: :get_by, var: var, queryable: queryable, clauses: clauses, opts: opts}
  end
  def get_by!(var, queryable, clauses, opts) do
    send self(), %{method: :get_by!, var: var, queryable: queryable, clauses: clauses, opts: opts}
  end
  def aggregate(var, queryable, aggregate, field, opts) do
    send self(), %{method: :aggregate, var: var, queryable: queryable, aggregate: aggregate, field: field, opts: opts}
  end
  def one(var, queryable, opts) do
    send self(), %{method: :one, var: var, queryable: queryable, opts: opts}
  end
  def one!(var, queryable, opts) do
    send self(), %{method: :one!, var: var, queryable: queryable, opts: opts}
  end
  def preload(var, struct_or_structs, preloads, opts) do
    send self(), %{method: :preload, var: var, struct_or_structs: struct_or_structs, preloads: preloads, opts: opts}
  end
  def all(var, queryable, opts) do
    send self(), %{method: :all, var: var, queryable: queryable, opts: opts}
  end
  def insert_all(var, schema_or_source, entries, opts) do
    send self(), %{method: :insert_all, var: var, schema_or_source: schema_or_source, entries: entries, opts: opts}
  end
  def update_all(var, queryable, updates, opts) do
    send self(), %{method: :update_all, var: var, queryable: queryable, updates: updates, opts: opts}
  end
  def delete_all(var, queryable, opts) do
    send self(), %{method: :delete_all, var: var, queryable: queryable, opts: opts}
  end
  def insert(var, struct_or_changeset, opts) do
    send self(), %{method: :insert, var: var, struct_or_changeset: struct_or_changeset, opts: opts}
  end
  def update(var, changeset, opts) do
    send self(), %{method: :update, var: var, changeset: changeset, opts: opts}
  end
  def insert_or_update(var, changeset, opts) do
    send self(), %{method: :insert_or_update, var: var, changeset: changeset, opts: opts}
  end
  def delete(var, struct_or_changeset, opts) do
    send self(), %{method: :delete, var: var, struct_or_changeset: struct_or_changeset, opts: opts}
  end
  def insert!(var, struct_or_changeset, opts) do
    send self(), %{method: :insert!, var: var, struct_or_changeset: struct_or_changeset, opts: opts}
  end
  def update!(var, changeset, opts) do
    send self(), %{method: :update!, var: var, changeset: changeset, opts: opts}
  end
  def insert_or_update!(var, changeset, opts) do
    send self(), %{method: :insert_or_update!, var: var, changeset: changeset, opts: opts}
  end
  def delete!(var, struct_or_changeset, opts) do
    send self(), %{method: :delete!, var: var, struct_or_changeset: struct_or_changeset, opts: opts}
  end

  def __adapter__(var) do
    send self(), %{method: :__adapter__, var: var}
  end
  def __log__(var, entry) do
    send self(), %{method: :__log__, var: var, entry: entry}
  end
  def config(var) do
    send self(), %{method: :config, var: var}
  end
  def start_link(var, opts) do
    send self(), %{method: :start_link, var: var, opts: opts}
  end
  def stop(var, pid, timeout) do
    send self(), %{method: :stop, var: var, pid: pid, timeout: timeout}
  end
  def transaction(var, fun_or_multi, opts) do
    send self(), %{method: :transaction, var: var, fun_or_multi: fun_or_multi, opts: opts}
  end
  def in_transaction?(var) do
    send self(), %{method: :in_transaction, var: var}
  end
  def  rollback(var, value) do
    send self(), %{method: :rollback, var: var, value: value}
  end
end
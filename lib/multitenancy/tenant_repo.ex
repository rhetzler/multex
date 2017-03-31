defmodule Multitenancy.TenantRepo do

    # various ways in which we annotate the inputs to enforce the tenant schema
    def tenant_annotated_query(query, conn, transform) do
        query |> Ecto.Queryable.to_query |> Map.put(:prefix, transform.(conn) )
    end
    def tenant_annotated_changeset(changeset , conn, transform) do
        %Ecto.Changeset{changeset | data: changeset.data |> Ecto.put_meta(prefix: transform.(conn)) }
    end
    def tenant_annotated_struct(struct, conn, transform) do
        struct |> Ecto.put_meta(prefix: transform.(conn))
    end

    # some helpers for inputs which may vary...
    def tenant_annotated_changeset_or_struct(%Ecto.Changeset{} = changeset , conn, transform) do
        tenant_annotated_changeset(changeset, conn, transform)
    end
    # If it's not a changeset, assume it's a data struct
    def tenant_annotated_changeset_or_struct(struct, conn, transform) do
        tenant_annotated_struct(struct, conn, transform)
    end

    defmacro __using__(opts) do
        quote bind_quoted: [opts: opts] do

        @repo Keyword.fetch!(opts, :repo)
        @transform Keyword.fetch!(opts, :transform)

        defmacro all(queryable, opts \\ []) do
            quote do
                unquote(@repo).all(unquote(queryable) |> Multitenancy.TenantRepo.tenant_annotated_query(var!(conn), unquote(@transform)), unquote(opts))
            end
        end
        defmacro get(queryable, id, opts \\ []) do
            quote do
                unquote(@repo).get(unquote(queryable) |> Multitenancy.TenantRepo.tenant_annotated_query(var!(conn), unquote(@transform)), unquote(id), unquote(opts))
            end
        end
        defmacro get!(queryable, id, opts \\ []) do
            quote do
                unquote(@repo).get!(unquote(queryable) |> Multitenancy.TenantRepo.tenant_annotated_query(var!(conn), unquote(@transform)), unquote(id), unquote(opts))
            end
        end
        defmacro get_by(queryable, clauses, opts \\ []) do
            quote do
                unquote(@repo).get_by(unquote(queryable) |> Multitenancy.TenantRepo.tenant_annotated_query(var!(conn), unquote(@transform)), unquote(clauses), unquote(opts))
            end
        end
        defmacro get_by!(queryable, clauses, opts \\ []) do
            quote do
                unquote(@repo).get_by!(unquote(queryable) |> Multitenancy.TenantRepo.tenant_annotated_query(var!(conn), unquote(@transform)), unquote(clauses), unquote(opts))
            end
        end
        defmacro one(queryable, opts \\ []) do
            quote do
                unquote(@repo).one(unquote(queryable) |> Multitenancy.TenantRepo.tenant_annotated_query(var!(conn), unquote(@transform)), unquote(opts))
            end
        end
        defmacro one!(queryable, opts \\ []) do
            quote do
                unquote(@repo).one!(unquote(queryable) |> Multitenancy.TenantRepo.tenant_annotated_query(var!(conn), unquote(@transform)), unquote(opts))
            end
        end

        defmacro aggregate(queryable, aggregate, field, opts \\ []) do
            quote do
                unquote(@repo).aggregate(unquote(queryable) |> Multitenancy.TenantRepo.tenant_annotated_query(var!(conn), unquote(@transform)), unquote(aggregate), unquote(field), unquote(opts))
            end
        end

        # does struct annotation need to be applied to "updates"
        defmacro update_all(queryable, updates, opts \\ []) do
            quote do
                unquote(@repo).update_all(unquote(queryable) |> Multitenancy.TenantRepo.tenant_annotated_query(var!(conn), unquote(@transform)), unquote(updates), unquote(opts))
            end
        end
        defmacro delete_all(queryable, opts \\ []) do
            quote do
                unquote(@repo).delete_all(unquote(queryable) |> Multitenancy.TenantRepo.tenant_annotated_query(var!(conn), unquote(@transform)), unquote(opts))
            end
        end


        defmacro insert(struct, opts \\ []) do
            quote do
                unquote(@repo).insert(unquote(struct) |> Multitenancy.TenantRepo.tenant_annotated_changeset_or_struct(var!(conn), unquote(@transform)), unquote(opts))
            end
        end
        defmacro insert!(struct, opts \\ []) do
            quote do
                unquote(@repo).insert!(unquote(struct) |> Multitenancy.TenantRepo.tenant_annotated_changeset_or_struct(var!(conn), unquote(@transform)), unquote(opts))
            end
        end

        defmacro update(struct, opts \\ []) do
            quote do
                unquote(@repo).update(unquote(struct) |> Multitenancy.TenantRepo.tenant_annotated_changeset_or_struct(var!(conn), unquote(@transform)), unquote(opts))
            end
        end
        defmacro update!(struct, opts \\ []) do
            quote do
                unquote(@repo).update!(unquote(struct) |> Multitenancy.TenantRepo.tenant_annotated_changeset_or_struct(var!(conn), unquote(@transform)), unquote(opts))
            end
        end
        defmacro insert_or_update(changeset, opts \\ []) do
            quote do
                unquote(@repo).insert_or_update(unquote(changeset) |> Multitenancy.TenantRepo.tenant_annotated_changeset_or_struct(var!(conn), unquote(@transform)), unquote(opts))
            end
        end
        defmacro insert_or_update!(changeset, opts \\ []) do
            quote do
                unquote(@repo).insert_or_update!(unquote(changeset) |> Multitenancy.TenantRepo.tenant_annotated_changeset_or_struct(var!(conn), unquote(@transform)), unquote(opts))
            end
        end

        defmacro delete(struct, opts \\ []) do
            quote do
                unquote(@repo).delete(unquote(struct) |> Multitenancy.TenantRepo.tenant_annotated_changeset_or_struct(var!(conn), unquote(@transform)), unquote(opts))
            end
        end
        defmacro delete!(struct, opts \\ []) do
            quote do
                unquote(@repo).delete!(unquote(struct) |> Multitenancy.TenantRepo.tenant_annotated_changeset_or_struct(var!(conn), unquote(@transform)), unquote(opts))
            end
        end

        # need a use case to verify preload or insert_all

    end

  end
end


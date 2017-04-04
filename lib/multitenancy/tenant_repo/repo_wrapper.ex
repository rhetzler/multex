defmodule Multitenancy.TenantRepo.RepoWrapper do

    # consider here using ApartmentEx's implementation, however it lacks the full set of function signatures... ?


    # wrapper methods
    def all(repo, prefix, queryable, opts \\ []) do
        repo.all( tenant_annotated_query(queryable, prefix), opts)
    end

    def stream(repo, prefix, queryable, opts \\ []) do
        repo.stream( tenant_annotated_query(queryable, prefix), opts)
    end

    def get(repo, prefix, queryable, id, opts \\ []) do
        repo.get( tenant_annotated_query(queryable, prefix), id, opts)
    end

    def get!(repo, prefix, queryable, id, opts \\ []) do
        repo.get!( tenant_annotated_query(queryable, prefix), id, opts)
    end

    def get_by(repo, prefix, queryable, clauses, opts \\ []) do
        repo.get_by( tenant_annotated_query(queryable, prefix), clauses, opts)
    end

    def get_by!(repo, prefix, queryable, clauses, opts \\ []) do
        repo.get_by!( tenant_annotated_query(queryable, prefix), clauses, opts)
    end

    def one(repo, prefix, queryable, opts \\ []) do
        repo.one( tenant_annotated_query(queryable, prefix), opts)
    end

    def one!(repo, prefix, queryable, opts \\ []) do
        repo.one!( tenant_annotated_query(queryable, prefix), opts)
    end

    def aggregate(repo, prefix, queryable, aggregate, field, opts \\ []) do
        repo.aggregate( tenant_annotated_query(queryable, prefix), aggregate, field, opts)
    end

    def insert_all(repo, prefix, schema_or_source, entries, opts \\ []) do
        repo.insert_all( tenant_annotated_changeset_or_struct(schema_or_source, prefix), entries, opts)
    end

    def update_all(repo, prefix, queryable, updates, opts \\ []) do
        repo.update_all( tenant_annotated_query(queryable, prefix), updates, opts)
    end

    def delete_all(repo, prefix, queryable, opts \\ []) do
        repo.delete_all( tenant_annotated_query(queryable, prefix), opts)
    end

    def insert(repo, prefix, struct, opts \\ []) do
        repo.insert( tenant_annotated_changeset_or_struct(struct, prefix), opts)
    end

    def update(repo, prefix, struct, opts \\ []) do
        repo.update( tenant_annotated_changeset_or_struct(struct, prefix), opts)
    end

    def insert_or_update(repo, prefix, changeset, opts \\ []) do
        repo.insert_or_update( tenant_annotated_changeset_or_struct(changeset, prefix), opts)
    end

    def delete(repo, prefix, struct, opts \\ []) do
        repo.delete( tenant_annotated_changeset_or_struct(struct, prefix), opts)
    end

    def insert!(repo, prefix, struct, opts \\ []) do
        repo.insert!( tenant_annotated_changeset_or_struct(struct, prefix), opts)
    end

    def update!(repo, prefix, struct, opts \\ []) do
        repo.update!( tenant_annotated_changeset_or_struct(struct, prefix), opts)
    end

    def insert_or_update!(repo, prefix, changeset, opts \\ []) do
        repo.insert_or_update( tenant_annotated_changeset_or_struct(changeset, prefix), opts)
    end

    def delete!(repo, prefix, struct, opts \\ []) do
        repo.delete!( tenant_annotated_changeset_or_struct(struct, prefix), opts)
    end


    # helper methods
    # various ways in which we annotate the inputs to enforce the tenant schema
    defp tenant_annotated_query(query, prefix) do
        query |> Ecto.Queryable.to_query |> Map.put(:prefix, prefix )
    end
    defp tenant_annotated_changeset(changeset, prefix) do
        %Ecto.Changeset{changeset | data: tenant_annotated_struct(changeset.data, prefix) }
    end
    defp tenant_annotated_struct(struct, prefix) do
        struct |> Ecto.put_meta(prefix: prefix)
    end

    # some helpers for inputs which may vary...
    defp tenant_annotated_changeset_or_struct(%Ecto.Changeset{} = changeset, prefix) do
        tenant_annotated_changeset(changeset, prefix)
    end
    # If it's not a changeset, assume it's a data struct
    defp tenant_annotated_changeset_or_struct(struct, prefix) do
        tenant_annotated_struct(struct, prefix)
    end

end
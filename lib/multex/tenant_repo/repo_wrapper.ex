defmodule Multex.TenantRepo.RepoWrapper do

  def identity(var) do
    var
  end

  defmacro __using__(options) do
    quote bind_quoted: [options: options] do

      alias Multex.TenantRepo.RepoWrapper

      @repo Keyword.fetch!(options, :repo)
      @transform (Keyword.get(options, :transform) || &RepoWrapper.identity/1)

      # wrapper methods
      def all( var, queryable, opts \\ []) do
        @repo.all( RepoWrapper.tenant_annotated_query(queryable, @transform.(var) ), opts)
      end

      def stream(var, queryable, opts \\ []) do
        @repo.stream( RepoWrapper.tenant_annotated_query(queryable, @transform.(var) ), opts)
      end

      def get(var, queryable, id, opts \\ []) do
        @repo.get( RepoWrapper.tenant_annotated_query(queryable, @transform.(var) ), id, opts)
      end

      def get!(var, queryable, id, opts \\ []) do
        @repo.get!( RepoWrapper.tenant_annotated_query(queryable, @transform.(var) ), id, opts)
      end

      def get_by(var, queryable, clauses, opts \\ []) do
        @repo.get_by( RepoWrapper.tenant_annotated_query(queryable, @transform.(var) ), clauses, opts)
      end

      def get_by!(var, queryable, clauses, opts \\ []) do
        @repo.get_by!( RepoWrapper.tenant_annotated_query(queryable, @transform.(var) ), clauses, opts)
      end

      def one(var, queryable, opts \\ []) do
        @repo.one( RepoWrapper.tenant_annotated_query(queryable, @transform.(var) ), opts)
      end

      def one!(var, queryable, opts \\ []) do
        @repo.one!( RepoWrapper.tenant_annotated_query(queryable, @transform.(var) ), opts)
      end

      def aggregate(var, queryable, aggregate, field, opts \\ []) do
        @repo.aggregate( RepoWrapper.tenant_annotated_query(queryable, @transform.(var) ), aggregate, field, opts)
      end

      def insert_all(var, schema_or_source, entries, opts \\ []) do
        @repo.insert_all( RepoWrapper.tenant_annotated_changeset_or_struct(schema_or_source, @transform.(var) ), entries, opts)
      end

      def update_all(var, queryable, updates, opts \\ []) do
        @repo.update_all( RepoWrapper.tenant_annotated_query(queryable, @transform.(var) ), updates, opts)
      end

      def delete_all(var, queryable, opts \\ []) do
        @repo.delete_all( RepoWrapper.tenant_annotated_query(queryable, @transform.(var) ), opts)
      end

      def insert(var, struct, opts \\ []) do
        @repo.insert( RepoWrapper.tenant_annotated_changeset_or_struct(struct, @transform.(var) ), opts)
      end

      def update(var, struct, opts \\ []) do
        @repo.update( RepoWrapper.tenant_annotated_changeset_or_struct(struct, @transform.(var) ), opts)
      end

      def insert_or_update(var, changeset, opts \\ []) do
        @repo.insert_or_update( RepoWrapper.tenant_annotated_changeset_or_struct(changeset, @transform.(var) ), opts)
      end

      def delete(var, struct, opts \\ []) do
        @repo.delete( RepoWrapper.tenant_annotated_changeset_or_struct(struct, @transform.(var) ), opts)
      end

      def insert!(var, struct, opts \\ []) do
        @repo.insert!( RepoWrapper.tenant_annotated_changeset_or_struct(struct, @transform.(var) ), opts)
      end

      def update!(var, struct, opts \\ []) do
        @repo.update!( RepoWrapper.tenant_annotated_changeset_or_struct(struct, @transform.(var) ), opts)
      end

      def insert_or_update!(var, changeset, opts \\ []) do
        @repo.insert_or_update( RepoWrapper.tenant_annotated_changeset_or_struct(changeset, @transform.(var) ), opts)
      end

      def delete!(var, struct, opts \\ []) do
        @repo.delete!( RepoWrapper.tenant_annotated_changeset_or_struct(struct, @transform.(var) ), opts)
      end
    end
  end


  # helper methods
  # various ways in which we annotate the inputs to enforce the tenant schema
  def tenant_annotated_query(query, prefix) do
    query |> Ecto.Queryable.to_query |> Map.put(:prefix, prefix )
  end
  def tenant_annotated_changeset(changeset, prefix) do
    %Ecto.Changeset{changeset | data: tenant_annotated_struct(changeset.data, prefix) }
  end
  def tenant_annotated_struct(struct, prefix) do
    struct |> Ecto.put_meta(prefix: prefix)
  end

  # some helpers for inputs which may vary...
  def tenant_annotated_changeset_or_struct(%Ecto.Changeset{} = changeset, prefix) do
    tenant_annotated_changeset(changeset, prefix)
  end
  # If it's not a changeset, assume it's a data struct
  def tenant_annotated_changeset_or_struct(struct, prefix) do
    tenant_annotated_struct(struct, prefix)
  end

end
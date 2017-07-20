defmodule Multex.TenantRepo.RepoWrapper do
  @moduledoc """
    RepoWrapper provides a set of functions which effectively delegate
    to a configured Repo, with the added functionality of taking
    an additional first parameter, transforming it, then applying
    it to the query/struct/changeset as a namespace specification

    See TenantRepo for more details
  """


  @doc """
  Identity function.

  an easy-to-reference [sic] method which applies the identity function as the
  RepoWrapper transform (useful for testing or custom use cases where transforms
  are pre-applied or unnecessary)

  use RepoWrapper, repo: MyRepo, transform: &Multext.TenantRepo.RepoWrapper.identity/1
  """
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
        @repo.insert_or_update!( RepoWrapper.tenant_annotated_changeset_or_struct(changeset, @transform.(var) ), opts)
      end

      def delete!(var, struct, opts \\ []) do
        @repo.delete!( RepoWrapper.tenant_annotated_changeset_or_struct(struct, @transform.(var) ), opts)
      end
    end
  end


  # helper methods
  # various ways in which we annotate the inputs to enforce the tenant schema
  @doc """
    Annotate the query with the supplied prefix

    This causes the query to be performed against the schema supplied by the prefix rather than the default schema
  """
  def tenant_annotated_query(query, prefix) do
    query |> Ecto.Queryable.to_query |> Map.put(:prefix, prefix )
  end
  @doc """
    Annotate the changeset with the supplied prefix

    This causes the changeset to be performed against the schema supplied by the prefix rather than the default schema
  """
  def tenant_annotated_changeset(changeset, prefix) do
    %Ecto.Changeset{changeset | data: tenant_annotated_struct(changeset.data, prefix) }
  end
  @doc """
    Annotate the struct with the supplied prefix

    This causes the struct operation to be performed against the schema supplied by the prefix rather than the default schema
  """
  def tenant_annotated_struct(struct, prefix) do
    struct |> Ecto.put_meta(prefix: prefix)
  end

  # some helpers for inputs which may vary...
  @doc """
    Annotate the changeset or struct with the supplied prefix

    This causes the changeset or struct operation to be performed against the schema supplied by the prefix rather than the default schema
  """
  def tenant_annotated_changeset_or_struct(%Ecto.Changeset{} = changeset, prefix) do
    tenant_annotated_changeset(changeset, prefix)
  end
  # If it's not a changeset, assume it's a data struct
  def tenant_annotated_changeset_or_struct(struct, prefix) do
    tenant_annotated_struct(struct, prefix)
  end

end
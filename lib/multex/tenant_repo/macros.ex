if Code.ensure_loaded?(Ecto) do

  defmodule Multex.TenantRepo.Macros do
    @moduledoc """
      Macros provides a set of macros which simulates the Ecto.Repo behaviour,
      while in practice passing an additional first parameter from the calling
      context to a wrapper module designed to accomodate the additional parameter

      See TenantRepo for more details
    """
    defmacro __using__(options) do
      quote bind_quoted: [options: options] do

        @context_variable Keyword.get(options, :context_variable)
        @wrapper_repo Keyword.get(options, :wrapper)

        def get_repo_context_var do
          quote do: var!(unquote(Macro.var(@context_variable,nil)))
        end

        defmacro all(queryable, opts \\ []) do
          quote do: unquote(get_repo_context_var()) |> unquote(@wrapper_repo).all( unquote(queryable), unquote(opts))
        end

        defmacro stream(queryable, opts \\ []) do
          quote do: unquote(get_repo_context_var()) |> unquote(@wrapper_repo).stream( unquote(queryable), unquote(opts))
        end

        defmacro get(queryable, id, opts \\ []) do
          quote do: unquote(get_repo_context_var()) |> unquote(@wrapper_repo).get( unquote(queryable), unquote(id), unquote(opts))
        end
        defmacro get!(queryable, id, opts \\ []) do
          quote do: unquote(get_repo_context_var()) |> unquote(@wrapper_repo).get!( unquote(queryable), unquote(id), unquote(opts))
        end

        defmacro get_by(queryable, clauses, opts \\ []) do
          quote do: unquote(get_repo_context_var()) |> unquote(@wrapper_repo).get_by( unquote(queryable), unquote(clauses), unquote(opts))
        end
        defmacro get_by!(queryable, clauses, opts \\ []) do
          quote do: unquote(get_repo_context_var()) |> unquote(@wrapper_repo).get_by!( unquote(queryable), unquote(clauses), unquote(opts))
        end

        defmacro one(queryable, opts \\ []) do
          quote do: unquote(get_repo_context_var()) |> unquote(@wrapper_repo).one( unquote(queryable), unquote(opts))
        end
        defmacro one!(queryable, opts \\ []) do
          quote do: unquote(get_repo_context_var()) |> unquote(@wrapper_repo).one!( unquote(queryable), unquote(opts))
        end

        defmacro aggregate(queryable, aggregate, field, opts \\ []) do
          quote do: unquote(get_repo_context_var()) |> unquote(@wrapper_repo).aggregate( unquote(queryable), unquote(aggregate), unquote(field), unquote(opts))
        end

        defmacro insert_all(schema_or_source, entries, opts \\ []) do
          quote do: unquote(get_repo_context_var()) |> unquote(@wrapper_repo).insert_all( unquote(schema_or_source), unquote(entries), unquote(opts))
        end

        defmacro update_all(queryable, updates, opts \\ []) do
          quote do: unquote(get_repo_context_var()) |> unquote(@wrapper_repo).update_all( unquote(queryable), unquote(updates), unquote(opts))
        end
        defmacro delete_all(queryable, opts \\ []) do
          quote do: unquote(get_repo_context_var()) |> unquote(@wrapper_repo).delete_all( unquote(queryable), unquote(opts))
        end

        defmacro insert(struct, opts \\ []) do
          quote do: unquote(get_repo_context_var()) |> unquote(@wrapper_repo).insert( unquote(struct), unquote(opts))
        end

        defmacro update(struct, opts \\ []) do
          quote do: unquote(get_repo_context_var()) |> unquote(@wrapper_repo).update( unquote(struct), unquote(opts))
        end

        defmacro insert_or_update(struct, opts \\ []) do
          quote do: unquote(get_repo_context_var()) |> unquote(@wrapper_repo).insert_or_update( unquote(struct), unquote(opts))
        end

        defmacro delete(struct, opts \\ []) do
          quote do: unquote(get_repo_context_var()) |> unquote(@wrapper_repo).delete( unquote(struct), unquote(opts))
        end

        defmacro insert!(struct, opts \\ []) do
          quote do: unquote(get_repo_context_var()) |> unquote(@wrapper_repo).insert!( unquote(struct), unquote(opts))
        end

        defmacro update!(struct, opts \\ []) do
          quote do: unquote(get_repo_context_var()) |> unquote(@wrapper_repo).update!( unquote(struct), unquote(opts))
        end

        defmacro insert_or_update!(struct, opts \\ []) do
          quote do: unquote(get_repo_context_var()) |> unquote(@wrapper_repo).insert_or_update!( unquote(struct), unquote(opts))
        end

        defmacro delete!(struct, opts \\ []) do
          quote do: unquote(get_repo_context_var()) |> unquote(@wrapper_repo).delete!( unquote(struct), unquote(opts))
        end

        # need a use case to verify preload

      end
    end
  end

end
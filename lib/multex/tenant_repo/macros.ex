defmodule Multex.TenantRepo.Macros do

  defmacro __using__(options) do
    quote bind_quoted: [options: options] do

      @context_variable Keyword.get(options, :context_variable)

      def get_var do
        quote do: var!(unquote(Macro.var(@context_variable,nil)))
      end

      defmacro all(queryable, opts \\ []) do
        quote do: unquote(get_var()) |> unquote(__MODULE__).Wrapper.all( unquote(queryable), unquote(opts))
      end

      defmacro get(queryable, id, opts \\ []) do
        quote do: unquote(get_var()) |> unquote(__MODULE__).Wrapper.get( unquote(queryable), unquote(id), unquote(opts))
      end
      defmacro get!(queryable, id, opts \\ []) do
        quote do: unquote(get_var()) |> unquote(__MODULE__).Wrapper.get!( unquote(queryable), unquote(id), unquote(opts))
      end

      defmacro get_by(queryable, clauses, opts \\ []) do
        quote do: unquote(get_var()) |> unquote(__MODULE__).Wrapper.get_by( unquote(queryable), unquote(clauses), unquote(opts))
      end
      defmacro get_by!(queryable, clauses, opts \\ []) do
        quote do: unquote(get_var()) |> unquote(__MODULE__).Wrapper.get_by!( unquote(queryable), unquote(clauses), unquote(opts))
      end

      defmacro one(queryable, opts \\ []) do
        quote do: unquote(get_var()) |> unquote(__MODULE__).Wrapper.one( unquote(queryable), unquote(opts))
      end
      defmacro one!(queryable, opts \\ []) do
        quote do: unquote(get_var()) |> unquote(__MODULE__).Wrapper.one!( unquote(queryable), unquote(opts))
      end

      defmacro aggregate(queryable, aggregate, field, opts \\ []) do
        quote do: unquote(get_var()) |> unquote(__MODULE__).Wrapper.aggregate( unquote(queryable), unquote(aggregate), unquote(field), unquote(opts))
      end

      defmacro update_all(queryable, updates, opts \\ []) do
        quote do: unquote(get_var()) |> unquote(__MODULE__).Wrapper.update_all( unquote(queryable), unquote(updates), unquote(opts))
      end
      defmacro delete_all(queryable, opts \\ []) do
        quote do: unquote(get_var()) |> unquote(__MODULE__).Wrapper.delete_all( unquote(queryable), unquote(opts))
      end

      defmacro insert(struct, opts \\ []) do
        quote do: unquote(get_var()) |> unquote(__MODULE__).Wrapper.insert( unquote(struct), unquote(opts))
      end
      defmacro insert!(struct, opts \\ []) do
        quote do: unquote(get_var()) |> unquote(__MODULE__).Wrapper.insert!( unquote(struct), unquote(opts))
      end

      defmacro update(struct, opts \\ []) do
        quote do: unquote(get_var()) |> unquote(__MODULE__).Wrapper.update( unquote(struct), unquote(opts))
      end
      defmacro update!(struct, opts \\ []) do
        quote do: unquote(get_var()) |> unquote(__MODULE__).Wrapper.update!( unquote(struct), unquote(opts))
      end

      defmacro insert_or_update(struct, opts \\ []) do
        quote do: unquote(get_var()) |> unquote(__MODULE__).Wrapper.insert_or_update( unquote(struct), unquote(opts))
      end
      defmacro insert_or_update!(struct, opts \\ []) do
        quote do: unquote(get_var()) |> unquote(__MODULE__).Wrapper.insert_or_update!( unquote(struct), unquote(opts))
      end

      defmacro delete(struct, opts \\ []) do
        quote do: unquote(get_var()) |> unquote(__MODULE__).Wrapper.delete( unquote(struct), unquote(opts))
      end
      defmacro delete!(struct, opts \\ []) do
        quote do: unquote(get_var()) |> unquote(__MODULE__).Wrapper.delete!( unquote(struct), unquote(opts))
      end

      # need a use case to verify preload or insert_all

    end
  end
end
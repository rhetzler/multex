defmodule Multitenancy.TenantRepo.Macros do

    def get_var_splice(context_var) do
        [ quote do: var!(unquote(Macro.var(context_var,nil))) ]
    end


    defmacro __using__(options) do
        quote bind_quoted: [options: options] do

            require Multitenancy.TenantRepo.RepoWrapper
            alias Multitenancy.TenantRepo.RepoWrapper
            alias Multitenancy.TenantRepo.Macros

            @repo Keyword.fetch!(options, :repo)
            @transform Keyword.fetch!(options, :transform)
            @context_variable Keyword.get(options, :context_variable)

            defmacro all(queryable, opts \\ []) do
                variable_splice = Macros.get_var_splice(@context_variable)
                quote do: RepoWrapper.all(unquote(@repo),unquote(@transform).( unquote_splicing( variable_splice )),
                    unquote(queryable), unquote(opts))
            end

            defmacro get(queryable, id, opts \\ []) do
                variable_splice = Macros.get_var_splice(@context_variable)
                quote do: RepoWrapper.get(unquote(@repo),unquote(@transform).( unquote_splicing( variable_splice )),
                    unquote(queryable), unquote(id), unquote(opts))
            end
            defmacro get!(queryable, id, opts \\ []) do
                variable_splice = Macros.get_var_splice(@context_variable)
                quote do: RepoWrapper.get!(unquote(@repo),unquote(@transform).( unquote_splicing( variable_splice )),
                    unquote(queryable), unquote(id), unquote(opts))
            end

            defmacro get_by(queryable, clauses, opts \\ []) do
                variable_splice = Macros.get_var_splice(@context_variable)
                quote do: RepoWrapper.get_by(unquote(@repo),unquote(@transform).( unquote_splicing( variable_splice )),
                    unquote(queryable), unquote(clauses), unquote(opts))
            end
            defmacro get_by!(queryable, clauses, opts \\ []) do
                variable_splice = Macros.get_var_splice(@context_variable)
                quote do: RepoWrapper.get_by!(unquote(@repo),unquote(@transform).( unquote_splicing( variable_splice )),
                    unquote(queryable), unquote(clauses), unquote(opts))
            end

            defmacro one(queryable, opts \\ []) do
                variable_splice = Macros.get_var_splice(@context_variable)
                quote do: RepoWrapper.one(unquote(@repo),unquote(@transform).( unquote_splicing( variable_splice )),
                    unquote(queryable), unquote(opts))
            end
            defmacro one!(queryable, opts \\ []) do
                variable_splice = Macros.get_var_splice(@context_variable)
                quote do: RepoWrapper.one!(unquote(@repo),unquote(@transform).( unquote_splicing( variable_splice )),
                    unquote(queryable), unquote(opts))
            end

            defmacro aggregate(queryable, aggregate, field, opts \\ []) do
                variable_splice = Macros.get_var_splice(@context_variable)
                quote do: RepoWrapper.aggregate(unquote(@repo),unquote(@transform).( unquote_splicing( variable_splice )),
                    unquote(queryable), unquote(aggregate), unquote(field), unquote(opts))
            end

            # does struct annotation need to be applied to "updates"
            defmacro update_all(queryable, updates, opts \\ []) do
                variable_splice = Macros.get_var_splice(@context_variable)
                quote do: RepoWrapper.update_all(unquote(@repo),unquote(@transform).( unquote_splicing( variable_splice )),
                    unquote(queryable), unquote(updates), unquote(opts))
            end
            defmacro delete_all(queryable, opts \\ []) do
                variable_splice = Macros.get_var_splice(@context_variable)
                quote do: RepoWrapper.delete_all(unquote(@repo),unquote(@transform).( unquote_splicing( variable_splice )),
                    unquote(queryable), unquote(opts))
            end

            defmacro insert(struct, opts \\ []) do
                variable_splice = Macros.get_var_splice(@context_variable)
                quote do: RepoWrapper.insert(unquote(@repo),unquote(@transform).( unquote_splicing( variable_splice )),
                    unquote(struct), unquote(opts))
            end
            defmacro insert!(struct, opts \\ []) do
                variable_splice = Macros.get_var_splice(@context_variable)
                quote do: RepoWrapper.insert!(unquote(@repo),unquote(@transform).( unquote_splicing( variable_splice )),
                    unquote(struct), unquote(opts))
            end

            defmacro update(struct, opts \\ []) do
                variable_splice = Macros.get_var_splice(@context_variable)
                quote do: RepoWrapper.update(unquote(@repo),unquote(@transform).( unquote_splicing( variable_splice )),
                    unquote(struct), unquote(opts))
            end
            defmacro update!(struct, opts \\ []) do
                variable_splice = Macros.get_var_splice(@context_variable)
                quote do: RepoWrapper.update!(unquote(@repo),unquote(@transform).( unquote_splicing( variable_splice )),
                    unquote(struct), unquote(opts))
            end

            defmacro insert_or_update(struct, opts \\ []) do
                variable_splice = Macros.get_var_splice(@context_variable)
                quote do: RepoWrapper.insert_or_update(unquote(@repo),unquote(@transform).( unquote_splicing( variable_splice )),
                    unquote(struct), unquote(opts))
            end
            defmacro insert_or_update!(struct, opts \\ []) do
                variable_splice = Macros.get_var_splice(@context_variable)
                quote do: RepoWrapper.insert_or_update!(unquote(@repo),unquote(@transform).( unquote_splicing( variable_splice )),
                    unquote(struct), unquote(opts))
            end

            defmacro delete(struct, opts \\ []) do
                variable_splice = Macros.get_var_splice(@context_variable)
                quote do: RepoWrapper.delete(unquote(@repo),unquote(@transform).( unquote_splicing( variable_splice )),
                    unquote(struct), unquote(opts))
            end
            defmacro delete!(struct, opts \\ []) do
                variable_splice = Macros.get_var_splice(@context_variable)
                quote do: RepoWrapper.delete!(unquote(@repo),unquote(@transform).( unquote_splicing( variable_splice )),
                    unquote(struct), unquote(opts))
            end

            # need a use case to verify preload or insert_all

        end
    end
end
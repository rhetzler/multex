if Code.ensure_loaded?(Ecto) do

  defmodule Multex.TenantRepo do
    @moduledoc """
      TenantRepo provides an Ecto Repo-like interface which ensures queries are directed to a separate
      schema via tenant-schema-isolation approach to multitenancy

      Objective: we want to create a TenantRepo wrapper inside our application which delegates
      to the standard application Ecto.Repo but adds the behaviour of transparently specifying the
      tenant prefix so the developer isn't burdened with this task (and prevents bugs... theoretically)

      Standard query looks like this:

          Repo.all( Model )

      in order to specifiy prefix, we have to annotate the query ( Model ) with the prefix:

          Repo.all( Model |> Ecto.Queryable.to_query |> Map.put(:prefix, "tenant_schema_prefix") )

      but this adds a burden on the developer and plenty of room for error:
        * this pattern diverges from Phoenix generation boilerplate
        * this pattern needs to be applied unilaterally to every [non-meta] query in your application

      Instead we want to provide the ability to do this:

          TenantRepo.all( Model )

      which would transparently bake in the necessary schema prefix.
      However, that prefix is dynamic per connection, so using a precompiled module is not viable.
      So we simulate this with macros.


          TenantRepo.all( Model )
          # expanded:
          context_variable |> RepoWrapper.all( Model )

      RepoWrapper has compile-time bindings to 2 project-specific entities:
        * Repo (our standard Repo which we are delegating queries to)
        * transform ( a function which derives the schema prefix from an available context_variable )

      The entire module interface, then requires 3 things:
        * Repo
        * transform
        * context_variable

      The default minimal implementation uses plug conn and the plugs provided by Multex:
          defmodule MyApplication.TenantRepo do
            use Multex.TenantRepo,
              repo: MyApplication.Repo
          end

      For more custom configuration, you can specify all 3 (assuming "tenant_uuid" variable is defined in the scope where TenantRepo macros are invoked)
          defmodule MyApplication.TenantRepo do
            def schema_from_uuid(uuid) do
              "schema_" <> uuid
            end
            use Multex.TenantRepo,
              repo: MyApplication.Repo,
              transform: &MyApplication.TenantRepo.schema_from_uuid/1,
              context_variable: :tenant_uuid
          end

    """

    def schema_from_conn(conn) do
      conn.assigns.tenant_schema
    end

    # use TenantRepo as a thin wrapper around TenantRepo.Macros with some defaults provided
    defmacro __using__(options) do
      quote bind_quoted: [options: options] do
        require Multex.TenantRepo.Macros
        require Multex.TenantRepo.RepoWrapper

        # To prevent namespace collsion with the macros, we put the Wrapper into a submodule
        #  this wrapper provides an additional 1st parameter which is transform()ed to our schema
        defmodule Wrapper do
          use Multex.TenantRepo.RepoWrapper,
              repo: Keyword.fetch!(options, :repo),
              transform: (Keyword.get(options, :transform) || &Multex.TenantRepo.schema_from_conn/1)
        end

        # Macros provides __MODULE__.<method> macros which bind the context_variable to the first parameter
        #  being passed to the __MODULE__.Wrapper for schema annotation (see RepoWrapper )
        use Multex.TenantRepo.Macros,
            wrapper: __MODULE__.Wrapper,
            context_variable: (Keyword.get(options, :context_variable) || :conn)

      end

    end
  end

end
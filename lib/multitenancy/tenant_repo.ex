defmodule Multitenancy.TenantRepo do
    @moduledoc """
    Yo Dawg. I heard you liked macros,
     so i wrote a macro that writes macros which splice macros into other macros.
    hope you like it.

    Objective: we want to create a TenantRepo wrapper inside our application which delegates
     to the standard application Ecto.Repo but adds the behaviour of transparently specifying the
     tenant prefix so the developer isn't burdened with this task (and prevents bugs... theoretically)

    Standard query looks like this:

    Repo.all( Model )

    in order to specifiy prefix, we have to annotate the query ( Model ) with the prefix:

     Model |> Ecto.Queryable.to_query |> Map.put(:prefix, "tenant_schema_prefix")

    but this adds an immense burden of room for error, as the patterns diverge from Phoenix generation boilerplate.
    Instead we want to provide the ability to do this:

    TenantRepo.all( Model )
    # which would transparently bake in the necessary schema prefix.
    # However, that prefix is dynamic per connection, so using a precompiled module is not viable.

    # instead, this approach seeks to provide a set of macros which accomplishes this.


    TenantRepo.all( Model )

    # therefore expands to (equivalently):

    Repo.all( Model |> Ecto.Queryable.to_query |> Map.put(:prefix, transform.(context_variable) )

    # where transform is a function that extracts the schema name from conn

    # This module provides the ability to parameterize the key aspects of this:
    #  Repo              - Ecto.Repo behaviour object being wrapped
    #  Transform         - Function to obtain schema name/prefix from context_variable
    #                        (this defaults to &Multitenancy.TenantRepo.schema_from_conn/1
    #                            which recieves the output of the conn plugs defined in this library)
    #  Context_variable  - Parameter bound dynamically from caller lexical scope.
    #                        (this defaults to :conn, attaching to phoenix `conn`-based controllers)


    # This can be configured in your application as follows:


    # default, minimal definition, uses phoenix conn and provided plugs:
    defmodule MyApplication.TenantRepo do
      use Multitenancy.TenantRepo,
        repo: UserService.Repo
    end

    # configrued, if the variable "tenant_uuid" is available in calling context
    #
    defmodule MyApplication.TenantRepo do
      def schema_from_uuid(uuid) do
        "schema_" <> uuid
      end
      use Multitenancy.TenantRepo,
        repo: MyApplication.Repo,
        transform: &MyApplication.TenantRepo.schema_from_uuid/1,
        context_variable: :tenant_uuid
    end

    """

    # transform: Multitenancy.TenantRepo.schema_from_conn/1
    def schema_from_conn(conn) do
      conn.assigns.tenant_schema
    end
    # transform: Multitenancy.TenantRepo.identity/1
    def identity(token) do
      token
    end

    # use TenantRepo as a thin wrapper around TenantRepo.Macros with some defaults provided
    defmacro __using__(options) do
        quote bind_quoted: [options: options] do
            require Multitenancy.TenantRepo.Macros

            use Multitenancy.TenantRepo.Macros,
                repo: Keyword.fetch!(options, :repo),
                transform: (Keyword.fetch!(options, :transform) || &Multitenancy.TenantRepo.schema_from_conn/1),
                context_variable: (Keyword.get(options, :context_variable) || :conn)

        end

    end
end


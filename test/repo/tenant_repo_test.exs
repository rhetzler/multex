defmodule TenantRepoTest.TenantRepoDefaults do
  use Multex.TenantRepo,
    repo: StubRepo
end

defmodule TenantRepoTest.TenantRepoConnIdent do
  use Multex.TenantRepo,
    repo: StubRepo,
    transform: &Multex.TenantRepo.RepoWrapper.identity/1
end

defmodule TenantRepoTest.TenantRepoSomeVarIdent do
  use Multex.TenantRepo,
    repo: StubRepo,
    transform: &Multex.TenantRepo.RepoWrapper.identity/1,
    context_variable: :some_var
end

defmodule Multex.TenantRepoTest do
    use ExUnit.Case, async: true
    use Multex.ConnCase

    require TenantRepoTest.TenantRepoDefaults
    require TenantRepoTest.TenantRepoConnIdent
    require TenantRepoTest.TenantRepoSomeVarIdent

    alias TenantRepoTest.TenantRepoDefaults
    alias TenantRepoTest.TenantRepoConnIdent
    alias TenantRepoTest.TenantRepoSomeVarIdent

    # validate queryable based functionality
    test "prefix_populated_for_queryable" do

      conn = conn(:get, "/hello") |> Plug.Conn.assign(:tenant_schema, "prefix_1")
      _result = TenantRepoDefaults.all( TestModel )

      assert_receive %{method: :all, queryable: ( %Ecto.Query{} = query ), opts: _ }

      refute query == TestModel
      assert query |> Map.get(:prefix) == "prefix_1"
      assert (query |> Map.put(:prefix, nil)) == (TestModel |> Ecto.Queryable.to_query())

    end

    # validate struct based functionality
    test "meta_populated_for_struct" do

      conn = conn(:get, "/hello") |> Plug.Conn.assign(:tenant_schema, "prefix_2")
      _result = TenantRepoDefaults.insert( %TestModel{name: "joe"} )

      assert_receive %{method: :insert, struct_or_changeset: ( %TestModel{} = struct ), opts: _ }

      refute struct == %TestModel{name: "joe"}
      assert struct |> Ecto.get_meta(:prefix) == "prefix_2"
      assert struct |> Ecto.put_meta(prefix: nil) == %TestModel{name: "joe"}

    end

    # validate changeset based functionality
    test "meta_populated_for_changeset" do

      conn = conn(:get, "/hello") |> Plug.Conn.assign(:tenant_schema, "prefix_3")
      _result = TenantRepoDefaults.insert( TestModel.changeset( %TestModel{}, %{name: "joe"}) )

      assert_receive %{method: :insert, struct_or_changeset: ( %Ecto.Changeset{} = changeset ), opts: _ }

      refute changeset.data == %TestModel{}
      assert changeset.data |> Ecto.get_meta(:prefix) == "prefix_3"
      assert changeset.data |> Ecto.put_meta(prefix: nil) == %TestModel{}

    end

    # validate overridden transforms
    test "prefix_populated_with_identity_transform" do

      conn = "prefix_4"
      _result = TenantRepoConnIdent.all( TestModel )

      assert_receive %{method: :all, queryable: ( %Ecto.Query{} = query ), opts: _ }

      refute query == TestModel
      assert query |> Map.get(:prefix) == "prefix_4"
      assert (query |> Map.put(:prefix, nil)) == (TestModel |> Ecto.Queryable.to_query())

    end

    # validate overridden context_variable
    test "prefix_populated_with_custom_context_variable" do

      some_var = "prefix_5"
      _result = TenantRepoSomeVarIdent.all( TestModel )

      assert_receive %{method: :all, queryable: ( %Ecto.Query{} = query ), opts: _ }

      refute query == TestModel
      assert query |> Map.get(:prefix) == "prefix_5"
      assert (query |> Map.put(:prefix, nil)) == (TestModel |> Ecto.Queryable.to_query())

    end

end
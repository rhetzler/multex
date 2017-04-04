defmodule MyTenantRepoDefaults do
  use Multex.TenantRepo,
    repo: StubRepo
end

defmodule MyTenantRepoConnIdent do
  use Multex.TenantRepo,
    repo: StubRepo,
    transform: &Multex.TenantRepo.RepoWrapper.identity/1
end

defmodule MyTenantRepoSomeVarIdent do
  def ident(var) do
    var
  end
  use Multex.TenantRepo,
    repo: StubRepo,
    transform: &MyTenantRepoSomeVarIdent.ident/1,
    context_variable: :some_var
end

defmodule Multex.TenantRepoTest do
    use ExUnit.Case, async: true
    use Multex.ConnCase

    require MyTenantRepoDefaults
    require MyTenantRepoConnIdent
    require MyTenantRepoSomeVarIdent

    # validate queryable based functionality
    test "prefix_populated_for_queryable" do

      conn = conn(:get, "/hello") |> Plug.Conn.assign(:tenant_schema, "prefix_1")
      _result = MyTenantRepoDefaults.all( TestModel )

      assert_receive %{method: :all, queryable: ( %Ecto.Query{} = query ), opts: _ }
      assert query |> Map.get(:prefix) == "prefix_1"

    end

    # validate struct based functionality
    test "meta_populated_for_struct" do

      conn = conn(:get, "/hello") |> Plug.Conn.assign(:tenant_schema, "prefix_2")
      _result = MyTenantRepoDefaults.insert( %TestModel{name: "joe"} )

      assert_receive %{method: :insert, struct_or_changeset: ( %TestModel{} = struct ), opts: _ }
      assert struct |> Ecto.get_meta(:prefix) == "prefix_2"

    end

    # validate changeset based functionality
    test "meta_populated_for_changeset" do

      conn = conn(:get, "/hello") |> Plug.Conn.assign(:tenant_schema, "prefix_3")
      _result = MyTenantRepoDefaults.insert( TestModel.changeset( %TestModel{}, %{name: "joe"}) )

      assert_receive %{method: :insert, struct_or_changeset: ( %Ecto.Changeset{} = changeset ), opts: _ }
      assert changeset.data |> Ecto.get_meta(:prefix) == "prefix_3"

    end

    # validate overridden transforms
    test "prefix_populated_with_identity_transform" do

      conn = "prefix_4"
      _result = MyTenantRepoConnIdent.all( TestModel )

      assert_receive %{method: :all, queryable: ( %Ecto.Query{} = query ), opts: _ }
      assert query |> Map.get(:prefix) == "prefix_4"

    end

    # validate overridden context_variable
    test "prefix_populated_with_custom_context_variable" do

      some_var = "prefix_5"
      _result = MyTenantRepoSomeVarIdent.all( TestModel )

      assert_receive %{method: :all, queryable: ( %Ecto.Query{} = query ), opts: _ }
      assert query |> Map.get(:prefix) == "prefix_5"

    end

end
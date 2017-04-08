defmodule DefaultMacros do
  use Multex.TenantRepo.Macros,
    wrapper: StubWrapper,
    context_variable: :conn
end

defmodule MacrosWithAlternateContextVariable do
  use Multex.TenantRepo.Macros,
    wrapper: StubWrapper,
    context_variable: :my_var
end


defmodule Multex.MacrosTest do
    use ExUnit.Case, async: true
    use Multex.ConnCase

    require DefaultMacros
    require MacrosWithAlternateContextVariable

    # validate queryable based functionality
    test "conn_passed_for_queryable" do

      conn = "prefix_1"
      _result = DefaultMacros.all( TestModel )

      assert_receive %{method: :all, var: var, queryable: query, opts: _ }

      assert query == TestModel
      # conn has been passed through
      assert var == conn

    end

    # validate struct based functionality
    test "conn_passed_for_struct" do

      conn = "prefix_2"
      _result = DefaultMacros.insert( %TestModel{name: "joe"} )

      assert_receive %{method: :insert, var: var, struct_or_changeset: struct, opts: _ }

      assert struct == %TestModel{name: "joe"}
      # conn has been passed through
      assert var == conn

    end

    # validate changeset based functionality
    test "conn_passed_for_changeset" do

      conn = "prefix_3"
      _result = DefaultMacros.insert( TestModel.changeset( %TestModel{}, %{name: "joe"}) )

      assert_receive %{method: :insert, var: var, struct_or_changeset: changeset, opts: _ }

      assert changeset == TestModel.changeset( %TestModel{}, %{name: "joe"})
      # conn has been passed through
      assert var == conn

    end

    # validate overridden transforms
    test "alternate_context_variable_passed_for_queryable" do

      my_var = "prefix_4"
      _result = MacrosWithAlternateContextVariable.all( TestModel )

      assert_receive %{method: :all, var: var, queryable: query , opts: _ }

      assert query == TestModel
      # my_var has be passed through
      assert var == my_var

    end


end
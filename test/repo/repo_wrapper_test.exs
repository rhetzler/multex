defmodule DefaultWrapperRepo do
  use Multex.TenantRepo.RepoWrapper,
    repo: StubRepo
end

defmodule WrapperRepoWithTransform do
  def transform(var) do
    "transformed_" <> var
  end
  use Multex.TenantRepo.RepoWrapper,
    repo: StubRepo,
    transform: &WrapperRepoWithTransform.transform/1
end

defmodule Multex.RepoWrapperTest do
    use ExUnit.Case, async: true
    use Multex.ConnCase

    require DefaultWrapperRepo
    require WrapperRepoWithTransform

    # validate queryable based functionality
    test "prefix_populated_for_queryable" do

      _result = "prefix_1" |> DefaultWrapperRepo.all( TestModel )

      assert_receive %{method: :all, queryable: ( %Ecto.Query{} = query ), opts: _ }
      assert query |> Map.get(:prefix) == "prefix_1"

    end

    # validate struct based functionality
    test "meta_populated_for_struct" do

      _result = "prefix_2" |> DefaultWrapperRepo.insert( %TestModel{name: "joe"} )

      assert_receive %{method: :insert, struct_or_changeset: ( %TestModel{} = struct ), opts: _ }
      assert struct |> Ecto.get_meta(:prefix) == "prefix_2"

    end

    # validate changeset based functionality
    test "meta_populated_for_changeset" do

      _result = "prefix_3" |> DefaultWrapperRepo.insert( TestModel.changeset( %TestModel{}, %{name: "joe"}) )

      assert_receive %{method: :insert, struct_or_changeset: ( %Ecto.Changeset{} = changeset ), opts: _ }
      assert changeset.data |> Ecto.get_meta(:prefix) == "prefix_3"

    end

    # validate transform functionality
    test "prefix_populated_for_queryable_using_transform" do

      _result = "prefix_4" |> WrapperRepoWithTransform.all( TestModel )

      assert_receive %{method: :all, queryable: ( %Ecto.Query{} = query ), opts: _ }
      assert query |> Map.get(:prefix) == "transformed_prefix_4"
    end

end
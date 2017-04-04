
defmodule TestModel do
  use Ecto.Schema

  import Ecto
  import Ecto.Changeset
  import Ecto.Query

  @primary_key {:id, :binary_id, autogenerate: true}

  schema "model" do
    field :name, :string
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name])
  end
end
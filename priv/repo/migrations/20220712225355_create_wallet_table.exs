defmodule PaymentServer.Repo.Migrations.CreateWalletTable do
  use Ecto.Migration

  def change do
    create table(:wallets) do 
      add :currency, :string
      add :value, :integer, default: 0
      add :user_id, references(:users, on_delete: :nothing)
    end

    create index(:wallets, [:user_id])
  end
end

defmodule PaymentServer.Repo.Migrations.UserAddAssociationToWallets do
  use Ecto.Migration

  def change do
    alter table(:users) do 
      add :wallet, references(:wallets, on_delete: :nothing)
    end
  end
end

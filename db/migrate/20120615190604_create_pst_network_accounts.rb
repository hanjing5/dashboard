class CreatePstNetworkAccounts < ActiveRecord::Migration
  def change
    create_table :pst_network_accounts do |t|

      t.timestamps
    end
  end
end

class CreatePstNetworkUsers < ActiveRecord::Migration
  def change
    create_table :pst_network_users do |t|

      t.timestamps
    end
  end
end

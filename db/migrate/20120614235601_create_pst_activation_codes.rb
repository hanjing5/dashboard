class CreatePstActivationCodes < ActiveRecord::Migration
  def change
    create_table :pst_activation_codes do |t|

      t.timestamps
    end
  end
end

class CreatePstResources < ActiveRecord::Migration
  def change
    create_table :pst_resources do |t|

      t.timestamps
    end
  end
end

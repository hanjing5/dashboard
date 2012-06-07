class CreatePstBlobs < ActiveRecord::Migration
  def change
    create_table :pst_blobs do |t|

      t.timestamps
    end
  end
end

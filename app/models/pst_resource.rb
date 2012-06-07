class PstResource < ActiveRecord::Base
  # attr_accessible :title, :body
    establish_connection("redshirt_storagecloud")
    set_table_name "PstResource"
end

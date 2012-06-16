class PstNetworkAccount < ActiveRecord::Base
  # attr_accessible :title, :body
    establish_connection("data1_networkid")
    set_table_name "PstNetworkAccount"
end

class PstActivationCode < ActiveRecord::Base
  # attr_accessible :title, :body
    establish_connection("data1_provisioning")
    set_table_name "PstActivationCode"
end

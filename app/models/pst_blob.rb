class PstBlob < ActiveRecord::Base
  # attr_accessible :title, :body
    establish_connection("redshirt_inception")
    set_table_name "PstBlob"
end

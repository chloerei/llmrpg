class ApplicationRecord < ActiveRecord::Base
  include UuidPrimaryKey

  primary_abstract_class
end

class FesYear < ActiveRecord::Base
  has_many :fes_date
  has_many :groups
end

class SubRep < ActiveRecord::Base
  belongs_to :group
  belongs_to :department
  belongs_to :grade
end

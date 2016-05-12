class PlaceAllowList < ActiveRecord::Base
  belongs_to :place
  belongs_to :group_category
end

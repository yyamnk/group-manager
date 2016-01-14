class StockerPlace < ActiveRecord::Base
  validates :name, :is_available_fesdate, presence: true
end

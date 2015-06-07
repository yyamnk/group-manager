class StageOrder < ActiveRecord::Base
  belongs_to :group
  belongs_to :fes_date
end

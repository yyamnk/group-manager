class StageOrder < ActiveRecord::Base
  belongs_to :group
  belongs_to :fes_date

  validates :group_id, :fes_date_id, :time, presence: true
  validates :group_id, :uniqueness => {:scope => [:fes_date_id, :is_sunny] }
end

class GroupProjectName < ActiveRecord::Base
  belongs_to :group

  validates_presence_of :project_name, :project_name
  validates_numericality_of :group_id
  validates :project_name, uniqueness: true
end

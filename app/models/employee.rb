class Employee < ActiveRecord::Base
  belongs_to :group
  belongs_to :employee_category

  validates_presence_of :group_id, :student_id, :name, :employee_category_id
  validates_numericality_of :group_id, :student_id, :employee_category_id, only_integer: true

  validates :student_id, format: { with: /(\A\d{8}+\z)/i }
end

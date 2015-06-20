class Employee < ActiveRecord::Base
  belongs_to :group
  belongs_to :employee_category
end

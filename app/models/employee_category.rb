class EmployeeCategory < ActiveRecord::Base

  def to_s
    self.name_ja
  end
end

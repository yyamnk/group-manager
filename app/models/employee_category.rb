class EmployeeCategory < ActiveRecord::Base

  # simple_form, activeadminで表示するカラムを指定
  # employee.employee_categoryがemployee.employee_category.name_jaと同等になる．
  def to_s
    self.name_ja
  end
end

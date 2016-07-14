module StoolTestPagesHelper
  def already_collected(employee)
    if @employees_dup.any?{|ed| ed.id == employee.id} then
      group_name = @employees.find_by(student_id: employee.student_id).group.name
      "#{group_name}にて徴収済み"
    end
  end

  def count_in_group(employees, group_id)
    if employees.class == Employee::ActiveRecord_Relation then
      employees.where(group_id: group_id).size
    else
      Employee.where(id: @employees_uniq).where(group_id: group_id).size
    end
  end

  def is_next_group(employees, employee, index)
    if employees.class == Array then
      employees = Employee.where(id: employees)
    end
    employees = employees.order(:group_id, :student_id)
    if employees[index - 1].group_id != employee.group_id then
      true
    else
      false
    end
  end

  def size_calibration(str)
    if str.length >= 10 then
      "10px"
    else
      "14px"
    end
  end

end

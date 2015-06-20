json.array!(@employees) do |employee|
  json.extract! employee, :id, :group_id, :name, :student_id, :employee_category_id, :duplication
  json.url employee_url(employee, format: :json)
end

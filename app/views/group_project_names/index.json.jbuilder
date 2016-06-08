json.array!(@group_project_names) do |group_project_name|
  json.extract! group_project_name, :id, :group_id, :project_name
  json.url group_project_name_url(group_project_name, format: :json)
end

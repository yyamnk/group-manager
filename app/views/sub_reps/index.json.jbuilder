json.array!(@sub_reps) do |sub_rep|
  json.extract! sub_rep, :id, :group_id, :name_ja, :name_en, :department_id, :grade_id, :tel, :email
  json.url sub_rep_url(sub_rep, format: :json)
end

class Employee < ActiveRecord::Base
  belongs_to :group
  belongs_to :employee_category
  has_many :food_products, through: :group

  # before_save :give_duplication
  # before_destroy :remove_duplication # レコードのdelete後に実行

  validates_presence_of :group_id, :student_id, :name, :employee_category_id
  validates_numericality_of :group_id, :student_id, :employee_category_id, only_integer: true

  validates :student_id, format: { with: /(\A\d{8}+\z)/i }

  validates :student_id, :uniqueness => {:scope => [:group_id] } # 団体と学籍番号でユニーク

  # 同じ学籍番号が登録されていれば重複を記録する
  def give_duplication
    same_student_ids = Employee.where(student_id: self.student_id)
    if same_student_ids.length > 1 then
      # selfのレコード + 他のレコードがあれば
      same_student_ids.each do |record|
        record.duplication = true
      end
    else
      # それ以外なら
      self.duplication = false
    end
  end

  # 削除される学籍番号と同じものが1つのみDBにあれば，
  # そのレコードのduplicationをfalseにする
  def remove_duplication
    same_student_ids = Employee.where(student_id: self.student_id)
    if same_student_ids.length == 2 then
      # selfのレコード + 他のレコードがあれば
      same_student_ids.each do |record|
        record.duplication = false
      end
    end
  end
end

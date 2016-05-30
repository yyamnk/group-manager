class ConfigUserPermission < ActiveRecord::Base
  validate :valid_boolean_unique

  validates_presence_of :form_name
  validates_uniqueness_of :form_name

  def valid_boolean_unique
    return unless [is_accepting, is_only_show].all?  # 全部0なら許可
    unless [is_accepting, is_only_show].one? # trueは1個のみ
      errors.add(:is_accepting, "全てチェックしないか，1個のみチェックしてください")
      errors.add(:is_only_show, "全てチェックしないか，1個のみチェックしてください")
    end
  end

end

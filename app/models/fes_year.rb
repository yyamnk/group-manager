class FesYear < ActiveRecord::Base
  has_many :fes_date
  has_many :groups

  def to_s # aciveAdminで表示名を指定する
    self.fes_year
  end
end

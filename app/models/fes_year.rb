class FesYear < ActiveRecord::Base
  has_many :fes_date
  has_many :groups

  def self.this_year
    FesYear.where(fes_year:Time.now.year).first
  end

  def to_s # aciveAdminで表示名を指定する
    self.fes_year
  end
end

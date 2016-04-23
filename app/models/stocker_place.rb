class StockerPlace < ActiveRecord::Base
  validates :name, :is_available_fesdate, presence: true

  def to_s # aciveAdmin, simple_formで表示名を指定する
    self.name
  end
end

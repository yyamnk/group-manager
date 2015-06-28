class FesDate < ActiveRecord::Base

  # simple_form, activeadminで表示するカラムを指定
  def to_s
    self.date
  end
end

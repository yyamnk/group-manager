class FesDate < ActiveRecord::Base

  belongs_to :fes_year

  validates :day, inclusion: {in: ['sun', 'mon', 'tue', 'wed', 'thu', 'fri', 'sat', 'holiday']}
  validates :days_num, inclusion: {in: [0, 1, 2]} # 準備日が0，1日目が1，2日目が2を示す．

  # simple_form, activeadminで表示するカラムを指定
  def to_s
    self.date
  end

end

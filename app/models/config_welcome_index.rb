class ConfigWelcomeIndex < ActiveRecord::Base

  validates_presence_of :name, :panel_partial
  # 半角英字と半角スペースのみ
  validates :panel_partial, format: { with: /\w/ }
  validates :enable_show, inclusion: {in: [false, true]}

end

ActiveAdmin.register Shop do

  permit_params :name, :tel, :time_weekdays, :time_sat, :time_sun, :time_holidays,:is_closed_sun, :is_closed_mon, :is_closed_tue, :is_closed_wed, :is_closed_thu, :is_closed_fri, :is_closed_sat, :is_closed_holiday, :kana

end

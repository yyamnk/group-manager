ActiveAdmin.register Shop do

  permit_params :name, :tel, :time_weekdays, :time_sat, :time_sun, :time_holidays

end

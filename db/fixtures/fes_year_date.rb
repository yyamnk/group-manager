FesYear.seed( :id,
  { id: 1, fes_year: '2015', } ,
  { id: 2, fes_year: '2016', } ,
  { id: 3, fes_year: '2017', } ,
  { id: 4, fes_year: '2018', } ,
  { id: 5, fes_year: '2019', } ,
  { id: 6, fes_year: '2020', } ,
)

FesDate.seed( :id,
  { id: 1, days_num:0, date: '準備日', day: 'fri', fes_year_id: 1} ,
  { id: 2, days_num:1, date: '1日目' , day: 'sat', fes_year_id: 1} ,
  { id: 3, days_num:2, date: '2日目' , day: 'sun', fes_year_id: 1} ,
  { id: 4, days_num:0, date: '準備日', day: 'fri', fes_year_id: 2} ,
  { id: 5, days_num:1, date: '1日目' , day: 'sat', fes_year_id: 2} ,
  { id: 6, days_num:2, date: '2日目' , day: 'sun', fes_year_id: 2} ,
)

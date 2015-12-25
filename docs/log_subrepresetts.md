<!-- ************** docs/log_subrepresetts.md **************
Created    : 2015-Dec-25
Last Change: 2015-Dec-25.
-->


副代表の追加

## CURD

```sh
$ bundle exec rails g scaffold SubRep group:references name_ja:string name_en:string department:references grade:references tel:string email:string
      invoke  active_record
      create    db/migrate/20151225141723_create_sub_reps.rb
      create    app/models/sub_rep.rb
      invoke  resource_route
       route    resources :sub_reps
      invoke  scaffold_controller
      create    app/controllers/sub_reps_controller.rb
      invoke    erb
      create      app/views/sub_reps
      create      app/views/sub_reps/index.html.erb
      create      app/views/sub_reps/edit.html.erb
      create      app/views/sub_reps/show.html.erb
      create      app/views/sub_reps/new.html.erb
      create      app/views/sub_reps/_form.html.erb
      invoke    helper
      create      app/helpers/sub_reps_helper.rb
      invoke    jbuilder
      create      app/views/sub_reps/index.json.jbuilder
      create      app/views/sub_reps/show.json.jbuilder
      invoke  assets
      invoke    coffee
      create      app/assets/javascripts/sub_reps.coffee
      invoke    scss
      create      app/assets/stylesheets/sub_reps.scss
      invoke  scss
   identical    app/assets/stylesheets/scaffolds.scss

$ vim db/migrate/20151225141723_create_sub_reps.rb
# null 制約を追加
$ rake db:migrate
== 20151225141723 CreateSubReps: migrating ====================================
-- create_table(:sub_reps)
   -> 0.0626s
== 20151225141723 CreateSubReps: migrated (0.0627s) ===========================
```

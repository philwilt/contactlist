# Mailer with Sucker Punch

Background processing within a single process
No need for another dyno on heroku

Install suckerpunch
gem 'sucker_punch'

Configure Backend
add this to app/config/application.rb
config.active_job.queue_adapter = :sidekiq


Generate a mailer

rails g mailer Contact

create class methods

fuck jobs

create controller

create model for validation

http://albertogrespan.com/blog/send-emails-in-the-background-using-sucker-punch/

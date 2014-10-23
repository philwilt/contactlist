# Active Job Action Mailer with Sucker Punch

This app is a boilerplate project for using Action Mailer with Active Job background processing with Rails 4.2. This allows you to send emails using a background process within a single process. If deploying to heroku, you have no need for a second dyno or complex setup.

Caveats: This is great for simple mailers, if you need something more complex I recommend using something like [Sidekiq](http://sidekiq.org). If you're using this for a contact form, you will have to persist the data in your database until the job has been completed. However, it is possible to just delete the object after the email has been sent (cheap hack).

This is a basic contact list sign up example. You could easily extend this to user sign up or other applications that need email.

## Install Rails

First you'll need to install rails 4.2. At the time of writing the newest Rails version is 4.2.0beta2. Using rvm:

```

$ rvm use ruby-2.1.3@rails4.2 --create
$ gem install rails --pre

```

Next create a new Rails project:

```

$ mkdir mailer && cd mailer
$ rails new .

```

## Install Sucker Punch

Now we're going to setup Sucker Punch. In Rails 4.2, we can configure ActiveJobs to use Sucker Punch as it's backend. This greatly simplifies our lives.

In your Gemfile add `gem 'sucker_punch'` and then run `bundle install`. Next configure Rails to Sucker Punch the backend!

```
# app/config/application.rb

class Application < Rails::Application
  config.active_job.queue_adapter = :sucker_punch
```

## Create a Contact

Now we're going to create a contact. You may use a Rails generator or create the files manually. But the end goal is to have the following pieces:


```
#app/models/contact.rb

class Contact < ActiveRecord::Base
  validates :name, :email, presence: true
end
```

```
# app/controller/contacts_controller.rb

class ContactsController < ApplicationController
  def new
    @contact = Contact.new
  end

  def create
    @contact = Contact.new(contact_params)

    if @contact.save
      ContactsMailer.welcome(@contact).deliver_later

      flash[:success] = "You have been added to my contacts!"
      redirect_to root_url
    else
      render :new
    end
  end

  private

  def contact_params
    params.require(:contact).permit(:name, :email)
  end
end
```

```
# config/routes.rb
resources :contacts, only: [:new, :create]
```

From this you can see we created a model with basic validations, and a controller with the new and create actions. We then added resources for those actions in our routes.

The real magic happening here in Rails 4.2 is the line:

```
ContactsMailer.welcome(@contact).deliver_later
```
This is what allows us to create an Active Job and send it to a Sucker Punch queue. In fact, we don't even have to setup logging like before as it Active Jobs will log by default. Pretty nice abstraction, ain't it? Of course, this won't work without a mailer, so let's set that up.

## Setup a Mailer

Now we will setup an Action Mailer to handle our our email needs. Again, you can use a generator or do this manually. The end goal is the following pieces:

```
# app/mailers/contacts_mailer.rb

class ContactsMailer < ActionMailer::Base
  default from: 'me@example.com'

  def welcome(contact)
    @contact = contact

    mail(to: @contact.email, subject: "Welcome to my list #{@contact.name}!")
  end
end

```

```
# app/views/contacts_mailer/welcome.html.erb

<%= "Welcome to my contacts list #{@contact.name}" %>
```

Great! Now, we are ready to sign up your friends!

### Add a Sign Up Form

The last piece of the puzzle! We'll add a sign up form so you can get all your friends' email addresses.

```
# app/views/contacts/new.html.erb

<% if @contact.errors.any? %>
  <div class='errors'>
      <ul>
      <% @contact.errors.full_messages.each do |msg| %>
        <li><%= msg %></li>
      <% end %>
    </ul>
  </div>
<% end %>

<%= form_for @contact do |f| %>
  <%= f.label :name, 'Name' %>
  <br />
  <%= f.text_field :name, { placeholder: "Jon Stewart" } %>
  <br />
  <%= f.label :email, 'Email' %>
  <br />
  <%= f.text_field :email, { placeholder: "example@email.com" } %>
  <br />
  <%= f.submit "Sign Up" %>
<% end %>
```

This form starts by showing any validation errors we may have run into. Then we have our input fields. Simple as that!

You're ready to add your favorite email provider and start spamming your friends!


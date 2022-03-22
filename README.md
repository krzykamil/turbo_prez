### Goal

The goal of this repo is to demo TurboRails as a tool to provide asynchronus, live updates to the client viewing the page.

It is mostly focused on providing it from a secondary process, that has no context of the client current session.

It also incorporates Trailblazer Cells as a tool to generate HTML.

In general the aim is to provide a look on how Turbo can be used outside of the simplistic examples provided by basecamp, that seem to not go further than traditional rails way, which makes the tool seem very limited.

The examples and code architecture is very simplistic still, as it aims to give you an idea of how the tool can be used to a very nice effect.

### Setup

Have redis installed

`bundle install`

`rake db:create db:migrate db:seed`

run sidekiq

`bundle exec sidekiq`

run server

`rails s`

run a rake task that runs some sidekiq tasks

`rake start`

open up posts index page in the browser and see the page getting updates live, from a process separated from the rails server. Incredible.


### Presentation

Link to finished presentation will go here

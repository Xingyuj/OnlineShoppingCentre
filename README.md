# Ebuy system
A C2C on-line shopping centre project, implementing in ruby on rails
## Installation

Dependencies:
- [rails](http://http://rubyonrails.org/)
- [git](http://git-scm.com/)
- [sqlite3](https://sqlite.org/)

Installing the project:
1. clone the repo
 
 ```
git clone git clone https://bitbucket.org/XingyuJi/swen90007project_ebuy.git # clone the repo
```
2. move into the repository directory
 
 ```
cd ebuy-shopping-centre
```
3. Install Rails at the command prompt if you haven't yet:
 
 ```
gem install rails # install the dependencies of the project
```
4. Install dependencies
 
 ```
gem install bundler
gem update bundler
bundle install
```
## Usage

To run the server:
```
rails s -r xxxx
```
where `XXXX` is the port number you wish to run the application on (if omit parameter -r the server will run on default port 3000)

## Documentation for libraries used

Server-side

- [role_model](https://github.com/martinrehfeld/role_model) RoleModel is the framework agnostic, efficient and declarative way to do (user) roles. Assigned roles will be efficiently stored as a bitmask directly into your model within a configurable attribute.
- [carrierwave](https://github.com/carrierwaveuploader/carrierwave) This gem provides a simple and extremely flexible way to upload files from Ruby applications. It works well with Rack based web applications, such as Ruby on Rails.
- [will_paginate](https://github.com/mislav/will_paginate)will_paginate is a pagination library that integrates with Ruby on Rails, Sinatra, Merb, DataMapper and Sequel.
- [devise](https://github.com/plataformatec/devise)Devise is a flexible authentication solution for Rails based on Warden.
- [sass-rails](https://github.com/rails/sass-rails) This gem provides official integration for Ruby on Rails projects with the Sass stylesheet language.
- [uglifier](https://github.com/lautis/uglifier) Use Uglifier as compressor for JavaScript assets
- [coffee-rails](https://github.com/rails/coffee-rails) Use CoffeeScript for .coffee assets and views

Client-side

- [jquery](http://jquery.com/) fast, small, and feature-rich javascript library that makes DOM-traversal easy
- [Bootstrap](http://getbootstrap.com/) as a good-looking CSS framework
- [jbuilder](https://github.com/rails/jbuilder) Build JSON APIs with ease.

All other frameworks used are either part of the above, dependencies of the above or perform a function to trivial to mention.

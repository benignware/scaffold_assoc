scaffold_assoc
==============

> Scaffolding nested resources in Rails

Install
-------

```
# Gemfile
gem "scaffold_assoc"
```

Usage
-----

Generate parent scaffold:
```
rails g scaffold Post title:string content:text
```

Generate association scaffold:
```
rails g scaffold_assoc Post/Comment title:string content:text
```

Hit `rake routes` to inspect nested resource routes.

Since scaffold_assoc only handles the association side of a model, you will have to add an has_many-relation to the parent model as well:

```ruby
# app/models/post.rb
class Post < ActiveRecord::Base
  has_many :comments
end
```

Customize views
---------------

The plugin ships with .erb and .haml-templates.

Install view templates to lib/rails/scaffold_assoc/templates:
```
rails g scaffold_assoc:install
```
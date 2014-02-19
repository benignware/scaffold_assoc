scaffold_assoc
==============

Nested scaffolding for rails 4


Usage
-----

```
# Gemfile
gem "scaffold_assoc", github: "rexblack/scaffold_assoc"
```

generate parent scaffold:
```
rails g scaffold Post title:string
```

generate association scaffold:
```
rails g scaffold_assoc Post/Comment content:text
```

install view templates to lib/rails/scaffold_assoc/templates:
```
rails g scaffold_assoc:install
```

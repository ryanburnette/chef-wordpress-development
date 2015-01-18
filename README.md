# chef-wordpress-development

This cookbook is meant to provision a [Vagrant][1] instance for local development
on a custom WordPress theme.

## Requirements

* mysql-server
* php5-fpm
* php5-mysql
* php5-cli
* nginx

## Automation

... need to document what this recipe is actually doing

## Recipes

### `default`

The default recipe does it all.

```
recipe[chef-wordpress-development]
```

## Data Bags

### `default`

```json
{
  "id": "default",
  "symlinks": [],
  "plugins": [],
  "production_url": ""
}
```

[1]: http://vagrantup.com

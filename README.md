# wordpress-development

This is my cookbook for provisioning a Vagrant instance for developing in
WordPress. It handles tasks that match my particular development pattern, but
with a few tweaks it might handle yours too. Feel free to fork and use it as a
basis for your own WordPress development.

The goal is to be able to run `vagrant up` in the root of a WordPress project
and have an environment that's pretty much ready to go.

## Usage

The default recipe contains all the automation. It need only be added to the run
list.

```
recipe[wordpress-development]
```

## Data Bags

Some of the required information must be set in the default data bag.

```json
{
  "id": "default",
  "symlinks": [
    "/home/vagrant/project/wordpress/wp-content/themes/project#/srv/development/wp-content/themes/project",
    "/home/vagrant/project/assets#/srv/development/assets"
  ],
  "plugins": [
    "wordpress-seo",
    "wp-markdown",
    "wp-pagenavi"
  ],
  "production_url": "http://production-site.com"
}
```

## License

Apache2

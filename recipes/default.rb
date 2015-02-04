plugins = data_bag_item("wordpress-development", "default")["plugins"]
symlinks = data_bag_item("wordpress-development", "default")["symlinks"]
production_url = data_bag_item("wordpress-development", "default")["production_url"]

bash "create mysql user and database" do
  code <<-EOF
    MYSQL=`which mysql`
    Q1="CREATE DATABASE IF NOT EXISTS development;"
    Q2="GRANT ALL ON development.* TO 'development'@'localhost' IDENTIFIED BY 'qqqqqq';"
    Q3="FLUSH PRIVILEGES;"
    SQL="${Q1}${Q2}${Q3}"
    $MYSQL -u root -p'qqqqqq' -e "$SQL"
  EOF
  user "root"
end

remote_file "/usr/local/bin/wp" do
  source "https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar"
  owner "vagrant"
  group "vagrant"
  mode 0774
end

bash "create /srv/development" do
  cwd "/srv"
  code <<-EOF
    mkdir development
    chown vagrant:vagrant development
  EOF
  user "root"
end  

bash "wp core download config install" do
  code <<-EOF
    cd /srv/development
    wp core download
    wp core config --dbname=development --dbuser=development --dbpass=qqqqqq
    wp core install --url=localhost --title=development --admin_user=ryan --admin_password=password --admin_email=ryan.burnette@gmail.com
  EOF
  user "vagrant"
  group "vagrant"
end

plugins.each do |plugin|
  bash "download #{plugin}" do
    cwd "/srv/development"
    code <<-EOF
      wp plugin install #{plugin} 
    EOF
    user "vagrant"
  end
end

symlinks.each do |pair|
  from = pair.split('#')[0]
  to = pair.split('#')[1]
  bash "symlink #{from} #{to}" do
    code <<-EOF
      ln -sf #{from} #{to}
    EOF
    user "vagrant"
  end
end

bash "set permissions" do
  cwd "/srv"
  code <<-EOF
    chown -R www-data:www-data development
  EOF
  user "root"
end

template "/etc/nginx/sites-available/development" do
  source "nginx-development.erb"
  mode 0644
  owner "root"
  group "root"
  variables({
    :production_url => production_url
  })
end

bash "enable nginx site" do
  code <<-EOF
    rm /etc/nginx/sites-enabled/default
    ln -sf /etc/nginx/sites-available/development /etc/nginx/sites-enabled/development
  EOF
  user "root"
end

bash "disable sendfile" do
  code <<-EOF
    sed -i 's/sendfile on/senfile off/g' /etc/nginx/nginx.conf
  EOF
  user "root"
end

service "nginx" do
  action :restart
end


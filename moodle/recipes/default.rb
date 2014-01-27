bash "setup_toodle" do
code <<-EOH
chkconfig nfs on
service nfs start
mkdir /tmp/toodle
cd /tmp/toodle
wget https://s3-ap-southeast-2.amazonaws.com/rpw-src/toodle/toodle-site.tgz
tar xf toodle-site.tgz
rm moodledata
cp -rf * /var/www
mkdir /var/www/moodledata
mount 172.31.2.24:/moodledata /var/www/moodledata
chgrp -R apache /var/www
chmod -R g+w /var/www
EOH
end

template "#{node[:apache][:dir]}/sites-enabled/toodle" do
  source 'toodle-default-site.erb'
  owner 'root'
  group 'root'
  mode 0644
  notifies :run, resources(:execute => 'logdir_existence_and_restart_apache2')
end

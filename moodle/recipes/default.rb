bash "setup_toodle" do
code <<-EOH
yum install gcc libstdc++-devel gcc-c++ fuse fuse-devel curl-devel libxml2-devel openssl-devel mailcap -y
chkconfig rpcbind on
chkconfig nfs on
service rpcbind start
service nfs start
mkdir /tmp/s3fs
cd /tmp/s3fs
wget http://s3fs.googlecode.com/files/s3fs-1.74.tar.gz 
tar xvzf s3fs-1.74.tar.gz
cd s3fs-1.74/
./configure --prefix=/usr
make
make install 
echo 'AKIAJJOMA3CAE74KMRAQ:2/d78bdutgKOLL7CurywxV9zHGjIZC9S86ZyFjaz' > /etc/passwd-s3fs
chmod 600 /etc/passwd-s3fs
mkdir /tmp/toodle
cd /tmp/toodle
wget https://s3-ap-southeast-2.amazonaws.com/rpw-src/toodle/toodle-site.tgz
tar xf toodle-site.tgz
cp -rf * /var/www
# mount 172.31.2.24:/moodledata /var/www/moodledata
s3fs s3moodlestore /var/www/moodledata
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

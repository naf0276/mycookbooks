
bash "setup_toodle" do
code <<-EOH
mkdir /tmp/toodle
cd /tmp/toodle
wget https://s3-ap-southeast-2.amazonaws.com/rpw-src/toodle/toodle-site.tgz
tar xf toodle-site.tgz
cp -rf * /var/www
chgrp -R apache /var/www
chmod -R g+w /var/www
EOH
end
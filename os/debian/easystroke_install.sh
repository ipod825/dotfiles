mkdir /tmp/easystroke_install
pushd /tmp/easystroke_install
wget http://ftp.ubuntu.com/ubuntu/pool/universe/e/easystroke/easystroke_0.6.0-0ubuntu11.debian.tar.xz
wget http://ftp.ubuntu.com/ubuntu/pool/universe/e/easystroke/easystroke_0.6.0-0ubuntu11.dsc
sudo apt-get install -y devscripts
sudo mk-build-deps -i easystroke_0.6.0-0ubuntu11.dsc
wget https://github.com/markdstjohn/easystroke/archive/master.tar.gz
tar zxf master.tar.gz
cd easystroke-master
make
sudo make install

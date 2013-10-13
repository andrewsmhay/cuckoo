#
# Cookbook Name:: cuckoo
# Recipe:: default
# Author:: Andrew Hay (andrew@cloudpassage.com)
#
# Copyright (C) 2013 CloudPassage, Inc.
# 
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# NOTE - STILL A WORK IN PROGRESS
#
package 'python' #installed by default
package 'python-magic' # for identifying file formats  
package 'python-dpkt' # for extracting info from pcaps  
package 'python-mako' # for rendering html reports and web gui  
package 'python-sqlalchemy'  
package 'python-jinja2' # necessary for web.py utility  
package 'python-bottle'
package 'ssdeep'
package 'python-pyrex' # required for pyssdeep installation  
package 'subversion'
package 'libfuzzy-dev'
package 'python-pymongo' # for mongodb support  
package 'mongodb' # includes server and clients  
package 'g++'
package 'libpcre3'
package 'libpcre3-dev'
package 'libcap2-bin'
package 'git'

# Checkout and setup pyssdeep
execute 'install pyssdeep' do
  command 'svn checkout http://pyssdeep.googlecode.com/svn/trunk/ /tmp/pyssdeep'
  command 'python /tmp/pyssdeep/setup.py build'
  command 'python /tmp/pyssdeep/setup.py install'
end
log 'pyssdeep downloaded and installed'

# Download yara
remote_file '/tmp/' do
  source 'http://yara-project.googlecode.com/files/yara-1.6.tar.gz'
  source 'http://yara-project.googlecode.com/files/yara-python-1.6.tar.gz'
end
log 'yara downloaded'

# Extract yara tar.gz file
execute 'install yara' do
  command 'tar -xvzf /tmp/yara-1.6.tar.gz'
  command './tmp/yara-1.6/configure'
  command './tmp/yara-1.6/make check'
  command './tmp/yara-1.6/make install'
end
log 'Finished yara installation'

# Extract and install yara-python tar.gz file
execute 'install yara-python' do
  command 'tar -xvzf /tmp/yara-python-1.6.tar.gz'
  command './tmp/yara-python-1.6/configure'
  command './tmp/yara-python-1.6/python setup.py build'
  command './tmp/yara-python-1.6/python setup.py install' 
end
log 'Finished python support installation'

# Configure tcpdump
execute 'config tcpump' do
  command 'setcap cap_net_raw,cap_net_admin=eip /usr/sbin/tcpdump'
  command 'getcap /usr/sbin/tcpdump > /tmp/getcap.out' # to check changes have been applied  
end
log 'tcpdump configured to work with Cuckoo'

user 'cuckoo'
log 'Created cuckoo user'
# Config cuckoo user
execute 'config cuckoouser' do
  command 'usermod -a -G vboxusers cuckoo' # add cuckoo to vboxusers group
end
log 'Added cuckoo user to the vboxusers group
'
# Download cuckoobox
execute 'config cuckoo' do
  command 'git clone git://github.com/cuckoobox/cuckoo.git /tmp'
end
log 'Cuckoo Sandbox downloaded from git://github.com/cuckoobox/ to /tmp'
log 'Cuckoo Sandbox host installed'

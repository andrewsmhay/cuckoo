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
execute 'checkout pyssdeep' do
  command 'svn checkout http://pyssdeep.googlecode.com/svn/trunk/ /tmp/pyssdeep'
end
execute 'build pyssdeep' do
  cwd '/tmp/pyssdeep'
  command 'python /tmp/pyssdeep/setup.py build'
  user 'root'
end
execute 'install pyssdeep' do
  cwd '/tmp/pyssdeep'
  command 'python /tmp/pyssdeep/setup.py install'
  user 'root'
end
log 'pyssdeep downloaded and installed'

# Download yara
remote_file '/tmp/' do
  source 'http://yara-project.googlecode.com/files/yara-1.6.tar.gz'
end
remote_file '/tmp/' do
  source 'http://yara-project.googlecode.com/files/yara-python-1.6.tar.gz'
end
log 'yara downloaded'

# Extract yara tar.gz file
execute 'download yara' do
  cwd '/tmp/'
  command 'tar -xvzf /tmp/yara-1.6.tar.gz'
end
execute 'configure yara' do
  cwd '/tmp/yara-1.6/'
  command './configure'
  user 'root'
end
execute 'check yara' do
  cwd '/tmp/yara-1.6/'
  command '.make check'
  user 'root'
end
execute 'install yara' do
  cwd '/tmp/yara-1.6/'
  command './make install'
  user 'root'
end
log 'Finished yara installation'

# Extract and install yara-python tar.gz file
execute 'extract yara-python' do
  cwd '/tmp/'
  command 'tar -xvzf /tmp/yara-python-1.6.tar.gz'
end
execute 'configure yara-python' do
  cwd '/tmp/yara-python-1.6/'
  command './configure'
  user 'root'
end
execute 'build yara-python' do
  cwd '/tmp/yara-python-1.6/'
  command 'python setup.py build'
  user 'root'
end
execute 'install yara-python' do
  cwd '/tmp/yara-python-1.6/'
  command 'python setup.py install'
  user 'root'
end
log 'Finished python support installation'

# Configure tcpdump
execute 'config tcpump' do
  command 'setcap cap_net_raw,cap_net_admin=eip /usr/sbin/tcpdump'
end
log 'tcpdump configured to work with Cuckoo'

user 'cuckoo'
log 'Created cuckoo user'
# Config cuckoo user
execute 'config cuckoouser' do
  command 'usermod -a -G vboxusers cuckoo' # add cuckoo to vboxusers group
end
log 'Added cuckoo user to the vboxusers group'

directory '/tmp/cuckoo/'
  action :create
end
# Download cuckoobox
execute 'config cuckoo' do
  command 'git clone git://github.com/cuckoobox/cuckoo.git /tmp/cuckoo'
end
log 'Cuckoo Sandbox downloaded from git://github.com/cuckoobox/ to /tmp/cuckoo'
log 'Cuckoo Sandbox host installed'

execute 'move cuckoo' do
  command 'mv /tmp/cuckoo /usr/'
  user 'root'
end

execute 'launch webui' do
  cwd '/usr/cuckoo/utils/'
  command 'python web.py'
  user 'root'
end
log 'WebUI Started'
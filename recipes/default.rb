#
# Cookbook:: webjs
# Recipe:: default
#
# Copyright:: 2020, The Authors, All Rights Reserved.

include_recipe 'line::default'

package 'httpd' do
  version '2.4.6'
  action :upgrade
end

## Should be using 'replace_only' method, but it doesn't actually exist in the line cookbook as docs say it should.
# NoMethodError: undefined method `replace_only' for cookbook: webjs, recipe: default :Chef::Recipe
replace_or_add 'Listen 80' do
  path '/etc/httpd/conf/httpd.conf'
  pattern 'Listen 80'
  line 'Listen 0.0.0.0:80'
  notifies :restart, 'service[httpd]', :immediately
end

service 'httpd' do
  action [:enable, :start]
  run_levels [3, 4, 5]
end

cookbook_file '/etc/yum.repos.d/mongodb-org-4.4.repo' do
  source 'mongodb-org-4.4.repo'
  mode '0755'
  owner 'root'
  group 'root'
end

package 'mongodb-org' do
  action :upgrade
end

service 'mongod' do
  action [:enable, :start]
end

include_recipe "nodejs::npm"

npm_package "deployd-cli" do
  action :install
end 

npm_package "forever" do
  action :install
end 

package 'git'

git '/usr/local/cpsc473_project01' do
  repository 'https://github.com/p0six/cpsc473_project01.git'
  revision 'master'
  action :sync
end

package 'python3' 

npm_package 'cpsc473_project01' do
  path '/usr/local/cpsc473_project01' # The root path to your project, containing a package.json file
  json true
  # notifies :run, 'execute[pip3 install requests]', :immediately
end

execute 'pip3 install requests'

execute 'forever start production.js | sleep 10' do
  cwd '/usr/local/cpsc473_project01'
  user 'root'
  not_if "ps -ewf | grep forever | grep -v grep"
  notifies :run, 'execute[python3 /usr/local/cpsc473_project01/eventData.py]', :delayed
end

execute 'python3 /usr/local/cpsc473_project01/eventData.py' do
  user 'root'
  action :nothing
end

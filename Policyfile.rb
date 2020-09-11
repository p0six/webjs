# Policyfile.rb - Describe how you want Chef Infra Client to build your system.
#
# For more information on the Policyfile feature, visit
# https://docs.chef.io/policyfile.html

# A name that describes what the system you're building with Chef does.
name 'webjs'

# Where to find external cookbooks:
default_source :supermarket

# run_list: chef-client will run these recipes in the order specified.
run_list 'webjs::default'

# Specify a custom source for a single cookbook:
cookbook 'webjs', path: '.'
cookbook 'line', '~> 2.9.0', :supermarket
# cookbook 'npm', '~> 0.1.2', :supermarket
# cookbook 'git', '~> 10.0.0', :supermarket
cookbook 'nodejs', '~> 7.0.1', :supermarket

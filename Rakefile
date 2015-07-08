require 'bundler/gem_tasks'

$LOAD_PATH.unshift File.expand_path('../lib', __FILE__)
require 'rbeapi/version'

task :build do
  system 'gem build rbeapi.gemspec'
end

RPM_OPTS = '--define "_topdir %(pwd)/rpmbuild" --define "_builddir ' \
  '%{_topdir}" --define "_rpmdir %(pwd)/rpms" --define "_srcrpmdir ' \
  '%{_rpmdir}" --define "_sourcedir  %(pwd)" --define "_specdir %(pwd)" -bb'
desc 'Generate regular and puppet-enterprise rbeapi RPMs for EOS'
task rpm: :build do
  system "sed -e 's/^Version:.*/Version: #{Rbeapi::VERSION}/g' " \
    'rbeapi.spec.tmpl > rbeapi.spec'
  system "rpmbuild #{RPM_OPTS} rbeapi.spec"
  system "rpmbuild #{RPM_OPTS} --define 'enterprise 1' rbeapi.spec"
  RPMS = `find rpms/noarch -name "*rbeapi*rpm"`
  puts "\n################################################\n#"
  puts "Created the following in rpms/noarch/\n#{RPMS}"
  puts "#\n################################################\n\n"
end

desc 'Package the inifile gem in to regular and puppet-enterprise RPMs for EOS'
task :inifile do
  # Get the latest version info
  INIFILE_VERSION = `wget -q  --output-document=- \
    https://rubygems.org/gems/inifile/versions.atom | \
    awk '/title>inifile/ {match($2, \"[0-9.]+\", a); print a[0]; exit}'`.strip
  system "gem fetch inifile --version '=#{INIFILE_VERSION}'"
  puts "Building rpm for inifile (#{INIFILE_VERSION})"
  system "sed -e 's/^Version:.*/Version: #{INIFILE_VERSION}/g' " \
    'gems/inifile/inifile.spec.tmpl > gems/inifile/inifile.spec'
  system "rpmbuild #{RPM_OPTS} gems/inifile/inifile.spec"
  system "rpmbuild #{RPM_OPTS} --define 'enterprise 1' " \
    'gems/inifile/inifile.spec'
  RPMS = `find rpms/noarch -name "*inifile*rpm"`
  puts "\n################################################\n#"
  puts "Created the following in rpms/noarch/\n#{RPMS}"
  puts "#\n################################################\n\n"
end

desc 'Package the net_http_unix gem in to an RPM for EOS'
task :net_http_unix do
  # Get the latest version info
  NET_HTTP_VERSION = `wget -q  --output-document=- \
    https://rubygems.org/gems/net_http_unix/versions.atom | awk \
    '/title>net_http_unix/ {match($2, \"[0-9.]+\", a); print a[0]; exit}'`.strip
  system "gem fetch net_http_unix --version '=#{NET_HTTP_VERSION}'"
  puts "Building rpm for net_http_unix (#{NET_HTTP_VERSION})"
  system "sed -e 's/^Version:.*/Version: #{NET_HTTP_VERSION}/g' " \
    'gems/net_http_unix/net_http_unix.spec.tmpl > ' \
    'gems/net_http_unix/net_http_unix.spec'
  system "rpmbuild #{RPM_OPTS} gems/net_http_unix/net_http_unix.spec"
  RPMS = `find rpms/noarch -name "*net_http_unix*rpm"`
  puts "\n################################################\n#"
  puts "Created the following in rpms/noarch/\n#{RPMS}"
  puts "#\n################################################\n\n"
end

desc 'Package the netaddr gem in to regular and puppet-enterprise RPMs for EOS'
task :netaddr do
  # Get the latest version info
  NETADDR_VERSION = `wget -q  --output-document=- \
    https://rubygems.org/gems/netaddr/versions.atom | \
    awk '/title>netaddr/ {match($2, \"[0-9.]+\", a); print a[0]; exit}'`.strip
  system "gem fetch netaddr --version '=#{NETADDR_VERSION}'"
  puts "Building rpm for netaddr (#{NETADDR_VERSION})"
  system "sed -e 's/^Version:.*/Version: #{NETADDR_VERSION}/g' " \
    'gems/netaddr/netaddr.spec.tmpl > gems/netaddr/netaddr.spec'
  system "rpmbuild #{RPM_OPTS} gems/netaddr/netaddr.spec"
  system "rpmbuild #{RPM_OPTS} --define 'enterprise 1' " \
    'gems/netaddr/netaddr.spec'
  RPMS = `find rpms/noarch -name "*netaddr*rpm"`
  puts "\n################################################\n#"
  puts "Created the following in rpms/noarch/\n#{RPMS}"
  puts "#\n################################################\n\n"
end

desc 'Generate all RPM packages needed for an EOS SWIX'
task all_rpms: :build do
  Rake::Task['rpm'].invoke
  Rake::Task['inifile'].invoke
  Rake::Task['net_http_unix'].invoke
  Rake::Task['netaddr'].invoke
  puts 'RPMs are available in rpms/noarch/'
  puts "Copy the RPMs to an EOS device then run the 'swix create' command."
  puts '  Examples: '
  puts '      Puppet Open Source: '
  puts '           cd /mnt/flash; \\'
  puts "           swix create rbeapi-#{Rbeapi::VERSION}-1.swix \\"
  puts "           rubygem-rbeapi-#{Rbeapi::VERSION}-1.eos4.noarch.rpm \\"
  puts '           rubygem-inifile-3.0.0-2.eos4.noarch.rpm \\'
  puts '           rubygem-netaddr-1.5.0-1.eos4.noarch.rpm \\'
  puts '           rubygem-net_http_unix-0.2.1-2.eos4.noarch.rpm'
  puts '      Puppet-enterprise: '
  puts '           cd/mnt/flash; \\'
  puts "           swix create pe-rbeapi-#{Rbeapi::VERSION}-1.swix \\"
  puts "           pe-rubygem-rbeapi-#{Rbeapi::VERSION}-1.eos4.noarch.rpm \\"
  puts '           pe-rubygem-inifile-3.0.0-2.eos4.noarch.rpm \\'
  puts '           pe-rubygem-netaddr-1.5.0-1.eos4.noarch.rpm'
end

task release: :build do
  system "gem push rbeapi-#{Rbeapi::VERSION}.gem"
end

solr_version = node[:solr][:version]

include_recipe "jetty::default"

remote_file "/tmp/solr-#{solr_version}.tgz" do
  source "http://it.apache.contactlab.it/lucene/solr/#{solr_version}/solr-#{solr_version}.tgz"
  not_if do FileTest.directory?("/usr/local/share/solr-#{solr_version}") end
end

execute "extract" do
  command "tar zxf solr-#{solr_version}.tgz"
  cwd "/tmp"
  not_if do FileTest.directory?("/usr/local/share/solr-#{solr_version}") end
end

execute "install solr" do
  command "mv /tmp/solr-#{solr_version} /usr/local/share"
  not_if do FileTest.directory?("/usr/local/share/solr-#{solr_version}") end
end

link "/var/lib/jetty/webapps/solr.war" do
  to "/usr/local/share/solr-#{solr_version}/dist/solr-#{solr_version}.war"
end

directory "/usr/local/share/solr" do
  owner "jetty"
  group "adm"
end

#file "/usr/local/share/solr/solr.xml" do
#  content('<solr persistent="true">
#   <cores adminPath="/admin/cores">' + node[:solr].map{|app| "<core name=\"#{app}\" instanceDir=\"#{app}\" dataDir=\"/usr/local/share/solr/#{app}/data\" />" 	}.join("") + '</cores>
#  </solr>')
#end

#node[:solr].each do |dir|
#  ["data", "data/index", "data/spellchecker"].each do |inside|
#	directory "/mnt/apps/#{dir}/current/solr/#{inside}" do
#   	  owner "jetty"
#   	  group "adm"
#  	end
#   end
#
#  link "/usr/local/share/solr/#{dir}" do
#    to "/mnt/apps/#{dir}/current/solr"
#  end

#end

service "jetty" do
  action :restart
end


require 'logger'
require 'fileutils'

log = Logger.new(STDOUT)

base_directory = File.expand_path(File.dirname(__FILE__))
log.info "Base Directory: #{base_directory}"

repo_dir = File.expand_path(File.join (base_directory,'../', 'repo', 'gluster'))

log.info "Repository Directory: #{repo_dir}"

unless File.directory? repo_dir
  log.info "Creating repository directory"
  FileUtils.mkdir_p(repo_dir)
end

log.info "Mirroring gluster rpms"
wget_status = system("wget -A rpm http://download.gluster.com/pub/gluster/glusterfs/LATEST/CentOS/6/ -nd -r -l1 -P #{repo_dir} -Nc")

if wget_status
  log.info "Sucessfully mirrored gluster rpms"
else
  log.error "Failed to mirror gluster rpms"
end

log.info "Creating gluster rpm repository"

createrepo_status = system("createrepo #{repo_dir}")
if createrepo_status
  log.info "Sucessfully created gluster repo"
else
  log.error "Failed to create gluster repo"
end



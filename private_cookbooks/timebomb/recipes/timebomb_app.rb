
# Install system-level packages
%w(python-pip git).each do |pkg|
  package pkg
end

# Create the deployment directory
deploy_dir = '/opt/timebomb'
directory deploy_dir + '/shared' do
  owner "root"
  group "root"
  mode 0755
  action :create
  recursive true
end

deploy_revision deploy_dir do
  repo 'git://github.com/leknarf/timebomb.git'
  migrate false # Don't run database migrations

  before_migrate do
    execute "install_python_dependencies" do
      command "pip install -r #{release_path}/requirements.txt"
    end
  end

  after_restart do
    kill_gunicorns = "ps -eo pid,command | grep gunicorn | grep -v grep | awk '{print $1}' | xargs kill"
    start_gunicorns = "gunicorn --daemon --workers 4 --bind 0.0.0.0:80 timebomb:app"
    execute "restart_app" do
      command "cd #{release_path}; #{kill_gunicorns}; #{start_gunicorns}"
    end
  end

  # Clear some default settings
  # Chef's deploy_revision is a direct port of Capistrano,
  # which includes some Rails-isms
  symlink_before_migrate.clear
  create_dirs_before_symlink.clear
  purge_before_symlink.clear
  symlinks.clear
end

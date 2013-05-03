include_recipe 'python::pip'

deploy_revision '/opt/timebomb' do
  repo 'git://github.com/leknarf/timebomb.git'
  migrate false # Don't run database migrations

  before_restart do
    execute "install_python_dependencies" do
      command "pip install -r requirements.txt"
      cwd release_path
    end
  end

  restart_command do
    kill_gunicorns = "ps -eo pid,command | grep gunicorn | grep -v grep | awk '{print $1}' | xargs kill"
    start_gunicorns = "gunicorn -w 4 timebomb:app"
    bash "restart_app" do
      code "#{kill_gunicorns} && #{start_gunicorns}"
    end
  end
end

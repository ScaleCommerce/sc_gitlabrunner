class sc_gitlabrunner::supervisor(
  $supervisor_exec_path   = '/usr/local/bin',
){
  include supervisord

  exec { 'stop-gitlab-runner-service':
    command => '/usr/bin/gitlab-runner stop',
    require     => Exec['gitlab-runner-restart'],
  }->
  supervisord::program { 'gitlab-runner':
    command     => "/usr/bin/gitlab-runner run --working-directory /home/gitlab-runner --config /etc/gitlab-runner/config.toml --service gitlab-runner --syslog --user gitlab-runner",
    autostart   => true,
    autorestart => true,
    require     => Exec['gitlab-runner-restart'],
  }
}
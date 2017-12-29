class sc_gitlabrunner::supervisor(
  $supervisor_exec_path   = '/usr/local/bin',
){
  include supervisord

  supervisord::program { 'gitlab-runner':
    command     => "/usr/bin/gitlab-ci-multi-runner run --working-directory /home/gitlab-runner --config /etc/gitlab-runner/config.toml --service gitlab-runner --syslog --user gitlab-runner",
    autostart   => true,
    autorestart => true,
    require     => Package['gitlab-ci-multi-runner'],
    before      => Service['gitlab-runner'],
  }->

  exec { 'supervisor-gitlab-runner-update':
    command => "/usr/local/bin/supervisorctl update",
  }
}
class sc_gitlabrunner (
  $gitlab_ci_runners = {},
){
  include "::gitlab_ci_multi_runner"
  create_resources('::gitlab_ci_multi_runner::runner', $gitlab_ci_runners)

  file { '/etc/init/gitlab-runner.conf':
    ensure => absent,
  }->
  file { '/etc/init.d/gitlab-runner':
    ensure => link,
    target => '/etc/supervisor.init/supervisor-init-wrapper',
  }

  file { '/etc/supervisor.d/gitlab-runner.conf':
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template("${module_name}/gitlab-runner.conf.erb"),
#    notify => Exec['supervisorctl_gitlab_ci_update'],
  }
#  exec {'supervisorctl_gitlab_ci_update':
#    command => '/usr/local/bin/supervisorctl update',
#    refreshonly => true,
#  }
}
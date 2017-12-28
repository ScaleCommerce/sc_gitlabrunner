class sc_gitlabrunner (
  $gitlab_ci_runners = {},
  $use_supervisor = true,
){

  if $use_supervisor {
    class {'::sc_gitlabrunner::supervisor':}
  }

  include "::gitlab_ci_multi_runner"
  include "::gitlab_ci_multi_runner::install"
}
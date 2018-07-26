class sc_gitlabrunner (
  $use_supervisor = true,
){

  if $use_supervisor {
    class {'::sc_gitlabrunner::supervisor':}
  }

  include gitlab::cirunner

  if (!$gitlab::cirunner::manage_repo) {
    Apt::Source['apt_gitlabci'] -> Package[gitlab-runner]
    Exec['apt_update'] -> Package[gitlab-runner]
  }
}

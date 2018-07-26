class sc_gitlabrunner (
  $use_supervisor = true,
){

  if $use_supervisor {
    class {'::sc_gitlabrunner::supervisor':}
  }

  include gitlab::cirunner
}

# tests for gitlab-runner
# installed?
describe package('gitlab-runner') do
 it { should be_installed }
end

# running in supervisor?
describe command('supervisorctl status gitlab-runner') do
  its('stdout') { should match 'RUNNING'}
end

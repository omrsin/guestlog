namespace :files do
	desc "Backups files before deploy"
	task :backup, roles :web do
		run "mkdir /home/#{user}/tmp"
		run "mv /home/#{user}/apps/#{application}/current/public/uploads/* /home/deployer/tmp"
	end
	before "deploy", "files:backup"
	before "deploy:cold", "files:backup"
end

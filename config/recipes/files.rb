namespace :files do
	desc "Backups image files"
	task :backup, roles: :web do
		run "mkdir /home/#{user}/tmp"
		run "mv /home/#{user}/apps/#{application}/current/public/uploads /home/#{user}/tmp"
	end
	before "deploy", "files:backup"
	before "deploy:cold", "files:backup"
	
	desc "restores image files" 
	task :restore, roles: :web do
		run "mv /home/#{user}/tmp/* /home/#{user}/apps/#{application}/current/public/"
		run "rm -rf /home/#{user}/tmp"
	end
	after "deploy", "files:restore"
	after "deploy:cold", "files:restore"

end

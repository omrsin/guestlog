require "bundler/capistrano"

load "config/recipes/base"
load "config/recipes/nginx"
load "config/recipes/unicorn"
load "config/recipes/postgresql"
load "config/recipes/nodejs"
load "config/recipes/rbenv"
load "config/recipes/check"
load "config/recipes/files"

server "198.74.50.103", :web, :app, :db, primary: true

set :user, 				"deployer"
set :application, "guestlog"
set :deploy_to, 	"/home/#{user}/apps/#{application}"
set :deploy_via,	:remote_cache
set :use_sudo, 		false

set :scm, 			 "git"
set :repository, "git@github.com:omrsin/#{application}.git"
set :branch, 		 "master"

default_run_options[:pty] = true
ssh_options[:forward_agent] = true

after "deploy", "deploy:cleanup"

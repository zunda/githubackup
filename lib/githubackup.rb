#
# Copyright (C) 2013 zunda <zunda at freeshell.org>
#
# This program is free software: you can redistribute it and/or
# modify it under the terms of the GNU General Public License as
# published by the Free Software Foundation, either version 2 of
# the License, or (at your option) any later version.
#
require 'open-uri'
require 'optparse'

require 'githubackup/repos'
require 'githubackup/copy'
require 'githubackup/endpoints'

module GitHuBackUp
	VERSION = '0.0.1'
	AGENT = "zunda@gmail.com - GitHuBackup - #{VERSION}"

	def GitHuBackUp.execute(*args)
		repos = Array.new
		dstdir = nil
		verbosity = 0
		really_execute = true

		op = OptionParser.new do |opts|
			opts.banner = "usaage: #{File.basename($0, '.rb')} [options] - backs up GitHub repositories"

			opts.on('-d', '--destination DIRECTORY', 'root directory of backup') do |directory|
				dstdir = directory
				puts "Destination directory is set to #{dstdir}" if verbosity > 1
			end

			opts.on('-u', '--user USER', 'repositories for GitHub user') do |user|
				puts "Fetching list of repositories for #{user}" if verbosity > 0
				r = Repos.parse_json(GitHuBackUp.read_json(GitHubApi.user_repos(user)))
				repos += r
				if verbosity > 1
					r.each do |repo|
						puts "Added repository #{repo.full_name}"
					end
				end
			end
			opts.on('-o', '--org ORGANIZATION', 'repositories for GitHub organization') do |org|
				puts "Fetching list of repositories for #{org}" if verbosity > 0
				r = Repos.parse_json(GitHuBackUp.read_json(GitHubApi.org_repos(org)))
				repos += r
				if verbosity > 1
					r.each do |repo|
						puts "Added repository #{repo.full_name}"
					end
				end
			end
			opts.on('-r', '--repository FULL_NAME', 'full name of GitHub repository') do |name|
				puts "Fetching information for repository #{name}" if verbosity > 0
				r = GitHub::Repo.parse_json(GitHuBackUp.read_json(GitHubApi.full_name_repo(name)))
				repos += [r]
				if verbosity > 1
					puts "Added repository #{r.full_name}"
				end
			end

			opts.on('-n', '--dryrun', 'avoid actual update') do
				really_execute = false
			end

			opts.on('-v', '--verbose', 'increase verbosity') do
				verbosity += 1
			end

			opts.on_tail('-V', '--version') do
				puts VERSION
				exit
			end
			opts.on_tail('-h', '--help') do
				puts opts
				exit
			end
		end

		begin
			op.parse!(args)
			if not dstdir
				raise OptionParser::ParseError, "Destination directory must be specified"
			end
			if repos.size < 1
				raise OptionParser::ParseError, "At least one repository must be specified"
			end
		rescue OptionParser::ParseError => e
			warn e
			$stderr.puts op
			exit
		end

		errors = false
		repos.each do |repo|
			if verbosity > 0
				if really_execute
					puts "Updating repository #{repo.full_name}"
				else
					puts "Pretending to update repository #{repo.full_name}"
				end
			end
			begin
				cmd = Copy.update_cmd(repo.full_name, repo.git_url, dstdir)
				if really_execute
					if verbosity < 2
						# hide output from commands
						cmd = "{ #{cmd}; } > /dev/null 2>&1"
					end
					system(cmd)
				end
			rescue CopyError => e
				$stderr.puts e
				errors = true
			end
		end

		exit errors ? 1 : 0
	end

	def GitHuBackUp.read_json(uri)
		open(uri, 'User-Agent' => AGENT).read
	end
end

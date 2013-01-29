#
# Copyright (C) 2013 zunda <zunda at freeshell.org>
#
# This program is free software: you can redistribute it and/or
# modify it under the terms of the GNU General Public License as
# published by the Free Software Foundation, either version 2 of
# the License, or (at your option) any later version.
#

class GitCopy
	def GitCopy.update_cmd(full_name, git_url, root_dst_dir)
		GitCopy.new(full_name, git_url, root_dst_dir).update_command
	end

	attr_reader :git_url
	attr_reader :full_name
	attr_reader :dst_dir

	def initialize(full_name, git_url, root_dst_dir)
		@full_name = full_name
		@git_url = git_url
		@root_dst_dir = root_dst_dir
		@dst_dir = File.join(@root_dst_dir, @full_name.split('/'))
		@parent_dir = File.dirname(@dst_dir)
	end

	attr_reader :parent_dir

	def can_pull?
		File.directory?(File.join((dst_dir), '.git'))
	end

	def can_clone?
		if not File.directory?(@root_dst_dir) or not File.writable?(@root_dst_dir)
			return false
		end
		if File.exist?(dst_dir)
			return false
		end
		if File.directory?(parent_dir) and not File.writable?(parent_dir)
			return false
		end
		return true
	end

	def update_command
		if can_pull?
			return "cd #{dst_dir}; git pull; cd -"
		elsif can_clone?
			cd_and_clone = "cd #{parent_dir}; git clone #{git_url}; cd -"
			if File.exists?(parent_dir)
				return cd_and_clone
			else
				return "mkdir -p #{parent_dir}; #{cd_and_clone}"
			end
		end
		raise GitCopyError, "Repository #{full_name} can not be pulled or cloned to #{dst_dir}"
	end
end

class GitCopyError < StandardError; end

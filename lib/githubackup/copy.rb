#
# Copyright (C) 2013 zunda <zunda at freeshell.org>
#
# This program is free software: you can redistribute it and/or
# modify it under the terms of the GNU General Public License as
# published by the Free Software Foundation, either version 2 of
# the License, or (at your option) any later version.
#
require 'uri'

module GitHuBackUp
	class Copy
		def Copy.update_cmd(full_name, git_url, root_dst_dir)
			Copy.new(full_name, git_url, root_dst_dir).update_cmd
		end

		attr_reader :git_url
		attr_reader :full_name
		attr_reader :dst_dir

		def initialize(full_name, git_url, root_dst_dir)
			@full_name = full_name
			@git_url = git_url
			@root_dst_dir = root_dst_dir
			begin
				uri_path = URI.parse(@git_url).path
			rescue URI::Error => e
				raise ValidationError, e
			end
			if not uri_path or uri_path.empty?
				raise ValidationError, 'There is no path in URL'
			end
			path = uri_path.split('/').reject{|e| e.empty?}
			unless path.reject{|e| e =~ /[\w\d]/}.empty?
				# We assume each element must have one or more alphabet or number
				raise ValidationError, 'Full name has invalid element'
			end
			@dst_dir = File.join(@root_dst_dir, path)
			@parent_dir = File.dirname(@dst_dir)
		end

		attr_reader :parent_dir

		FILES_IN_MIRROR = %w(config description HEAD packed-refs)
		# File FETCH and FETCH_HEAD might not be in some bare repositories
		DIRS_IN_MIRROR = %w(branches hooks info objects refs)

		def can_fetch?
			if not File.directory?(dst_dir)
				return false
			end
			FILES_IN_MIRROR.each do |f|
				if not File.file?(File.join(dst_dir, f))
					return false
				end
			end
			DIRS_IN_MIRROR.each do |d|
				if not File.directory?(File.join(dst_dir, d))
					return false
				end
			end
			return true
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

		def update_cmd
			if can_fetch?
				return "cd '#{dst_dir}'; git fetch -v; cd -"
			elsif can_clone?
				cd_and_clone = "cd '#{parent_dir}'; git clone --mirror '#{git_url}'; cd -"
				if File.exists?(parent_dir)
					return cd_and_clone
				else
					return "mkdir -p '#{parent_dir}'; #{cd_and_clone}"
				end
			end
			raise CopyError, "Repository #{full_name} can not be fetched or cloned to #{dst_dir}"
		end
	end

	class CopyError < StandardError; end
	class ValidationError < StandardError; end
end

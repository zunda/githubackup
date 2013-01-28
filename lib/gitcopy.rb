#
# Copyright (C) 2013 zunda <zunda at freeshell.org>
#
# This program is free software: you can redistribute it and/or
# modify it under the terms of the GNU General Public License as
# published by the Free Software Foundation, either version 2 of
# the License, or (at your option) any later version.
#

class GitCopy
	def initialize(full_name, git_url, root_dst_dir)
		@full_name = full_name
		@git_url = git_url
		@root_dst_dir = root_dst_dir
	end

	def dst_dir
		File.join(@root_dst_dir, @full_name.split('/'))
	end
end

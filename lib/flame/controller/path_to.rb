# frozen_string_literal: true

module Flame
	class Controller
		## Module with methods for path or URL building
		module PathTo
			## Look documentation at {Flame::Dispatcher#path_to}
			def path_to(*args)
				add_controller_class(args)
				@dispatcher.path_to(*args)
			end

			## Build a URI to the given controller and action, or path
			def url_to(*args, **options)
				first_arg = args.first
				path =
					if first_arg.is_a?(String) || first_arg.is_a?(Flame::Path)
						find_static(first_arg).path(with_version: options[:version])
					else
						path_to(*args, **options)
					end
				Addressable::URI.new(
					scheme: request.scheme, host: request.host_with_port, path: path
				).to_s
			end

			using GorillaPatch::Namespace

			## Path to previous page, or to index action, or to Index controller
			## @return [String] path to previous page or to index
			def path_to_back
				back_path = request.referer
				return back_path if back_path && back_path != request.url
				return path_to :index if self.class.actions.include?(:index)
				'/'
			end
		end
	end
end

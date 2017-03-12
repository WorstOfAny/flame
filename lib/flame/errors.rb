# frozen_string_literal: true
module Flame
	module Errors
		module RouterError
			## Error for Route initialization
			class RouteArgumentsError < StandardError
				def initialize(ctrl, action, path, extra)
					@ctrl = ctrl
					@action = action
					@path = path
					@extra = extra
					@extra[:type_name] = {
						req: 'required',
						opt: 'optional'
					}[@extra[:type]]
				end

				def message
					case @extra[:place]
					when :ctrl
						## Error if path has no arguments, that controller's method has
						"Path '#{@path}' has no #{@extra[:type_name]}" \
							" arguments #{@extra[:args].inspect}"
					when :path
						## Error if path has more arguments, than controller's method
						"Action '#{@ctrl}##{@action}' has no #{@extra[:type_name]}" \
							" arguments #{@extra[:args].inspect}"
					end
				end
			end
		end

		## Error for Flame::Router.find_path
		class RouteNotFoundError < StandardError
			def initialize(ctrl, method)
				@ctrl = ctrl
				@method = method
			end

			def message
				"Route with controller '#{@ctrl}' and method '#{@method}'" \
				' not found in application routes'
			end
		end

		## Error for Flame::Controller.path_to
		class ArgumentNotAssignedError < StandardError
			def initialize(path, path_part)
				@path = path
				@path_part = path_part
			end

			def message
				"Argument '#{@path_part}' for path '#{@path}' is not assigned"
			end
		end

		## Error for Flame::Router.find_path
		class UnexpectedTypeOfHookError < StandardError
			def initialize(hook, route)
				@hook = hook
				@route = route
			end

			def message
				"Unexpected hook-block class '#{@hook.class}'" \
				" in route '#{@route}'"
			end
		end
	end
end

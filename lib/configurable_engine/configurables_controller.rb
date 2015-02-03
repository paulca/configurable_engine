module ConfigurableEngine
  module ConfigurablesController
    def show
      @keys = Configurable.keys
    end

    def update
      failures = Configurable.keys.map do |key|
          Configurable.find_by_name(key) ||
            Configurable.create { |c| c.name = key }
        end.reject do |configurable|
          configurable.value = configurable_params[configurable.name]
          configurable.save
        end

      if failures.empty?
        redirect_to ConfigurableEngine.custom_route, notice: "Changes successfully updated"
      else
        flash[:error] = failures.flat_map(&:errors).flat_map(&:full_messages).join(',')

        redirect_to ConfigurableEngine.custom_route
      end
    end

    def configurable_params
      if ConfigurableEngine.active_record_protected_attributes?
        params
      else
        params.require(:configurable).tap do |whitelisted|
          Configurable.keys.map(&:to_sym).each do |key|
            whitelisted[key] = params[:configurable][key]
          end
        end
      end
    end
  end
end

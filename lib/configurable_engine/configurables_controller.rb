module ConfigurableEngine
  module ConfigurablesController
    def show
      @keys = Configurable.keys
    end

    def update
      failures = Configurable
        .keys.map do |key|
          configurable = Configurable.find_by_name(key) ||
              Configurable.create {|c| c.name = key}
        end.reject do |configurable|
          configurable.update_attributes(value: params[configurable.name])
        end

      if failures.empty?
        redirect_to admin_configurable_path, :notice => "Changes successfully updated"
      else
        redirect_to admin_configurable_path, :alert => failures.flat_map(&:errors).flat_map(&:full_messages).join(',')
      end
    end
  end
end
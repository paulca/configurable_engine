module ConfigurableEngine
  module ConfigurablesControllerMethods
    def show
      @keys = Configurable.keys
    end

    def update
      failures = Configurable
        .keys.map do |key|
          Configurable.find_by_name(key) ||
            Configurable.create {|c| c.name = key}
        end.reject do |configurable|
          configurable.value = params[configurable.name]
          configurable.save
        end

      if failures.empty?
        redirect_to configurable_path, :notice => "Changes successfully updated"
      else
        flash[:error] = failures.flat_map(&:errors).flat_map(&:full_messages).join(',')
        redirect_to configurable_path
      end
    end
  end
end

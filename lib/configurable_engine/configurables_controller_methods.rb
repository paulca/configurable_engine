module ConfigurableEngine
  module ConfigurablesControllerMethods
    def show
      @keys = Configurable.keys
      render 'configurable_engine/configurables/show'
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
        redirect_to(action: :show, :notice => "Changes successfully updated")
      else
        flash[:error] = failures.flat_map(&:errors).flat_map(&:full_messages).join(',')
        redirect_to(action: :show)
      end
    end
  end
end

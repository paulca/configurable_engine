module ConfigurableEngine
  module ConfigurablesController
    def show

    end

    def update
      Configurable.keys.each do |key|
        configurable = Configurable.find_by_name(key) ||
            Configurable.create {|c| c.name = key}
        configurable.update_attribute(:value,params[key])
      end
      redirect_to admin_configurable_path
    end
  end
end
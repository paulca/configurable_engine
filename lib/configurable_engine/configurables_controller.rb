module ConfigurableEngine
  module ConfigurablesController
    def show

    end

    def update
      Configurable.keys.each do |key|
        Configurable.find_or_create_by_name(key).
                     update_attribute(:value,params[key])
      end
      redirect_to admin_configurable_path
    end
  end
end
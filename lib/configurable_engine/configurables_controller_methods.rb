# frozen_string_literal: true

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
          Configurable.create { |c| c.name = key }
      end.reject do |configurable|
        configurable.value = params[configurable.name]
        configurable.save
      end

      if failures.empty?
        redirect_to(action: :show, notice: 'Changes successfully updated')
      else
        flash[:error] = failures.map { |c| [c, c.errors] }.flat_map { |c, e|
          e.full_messages.map { |m|
            "#{c.name} #{m.downcase}"
          }
        }.join(',')
        redirect_to(action: :show)
      end
    end
  end
end

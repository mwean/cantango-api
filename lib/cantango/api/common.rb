module CanTango::Api
  module Common
    def create_ability candidate, opts = {}
      ability = CanTango::Ability::Base.new candidate, opts
      config.ability.factory_build ability, opts.merge(:modes => execution_modes)
    end

    def category label
      config.models.by_category label
    end
    
    protected

    def execution_modes
      CanTango.config.ability.modes || [:no_cache]
    end
    
    def config
      CanTango.config
    end
  end
end


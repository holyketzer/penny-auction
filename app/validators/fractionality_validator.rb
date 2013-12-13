class FractionalityValidator < ActiveModel::EachValidator
  CHECKS = { greater_than: :>, greater_than_or_equal_to: :>=,
                 equal_to: :==, less_than: :<, less_than_or_equal_to: :<=,
                 other_than: :!= }.freeze

  def validate_each(record, attribute, value)
    if value
      value = value.modulo(1)

      options.slice(*CHECKS.keys).each do |option, option_value|        
        case option_value
        when Proc
          option_value = option_value.call(record)
        when Symbol
          option_value = record.send(option_value)
        end

        unless value.send(CHECKS[option], option_value)
          record.errors[attribute] << (options[:message] || "fractional part should be #{option} #{option_value}")
        end
      end
    end
  end
end
class FractionalityValidator < ActiveModel::EachValidator

  def validate_each(record, attr_name, value)
    before_type_cast = :"#{attr_name}_before_type_cast"

    raw_value = record.send(before_type_cast) if record.respond_to?(before_type_cast)
    raw_value ||= value

    return if options[:allow_nil] && raw_value.nil?
      
    unless raw_value = parse_raw_value_as_a_float_number(raw_value)
      record.errors[attr_name] << (options[:message] || "should be value with floating point")
      return
    end

    frac_match = /[\.,]\d+/.match(raw_value.to_s)    
    if frac_match
      raw_value = Kernel.Float(frac_match[0])

      multiplier = options[:multiplier]
      if raw_value != 0 and multiplier      
        case multiplier
        when Proc
          multiplier = multiplier.call(record)
        when Symbol
          multiplier = record.send(multiplier)
        end
        
        if raw_value < multiplier || raw_value.to_s.size > multiplier.to_s.size
          record.errors[attr_name] << (options[:message] || "should be multiplication of #{multiplier}")
        end
      end
    end
  end

  protected
    def parse_raw_value_as_a_float_number(raw_value)
      return raw_value if raw_value.is_a? Float or raw_value.is_a? Rational
      return nil if raw_value.is_a? Integer

      if raw_value !~ /\A0[xX]/ and Kernel.Float(raw_value)
        begin
          nil if Kernel.Integer(raw_value, 10)
        rescue ArgumentError, TypeError
          Kernel.Float(raw_value)
        end
      end
    rescue ArgumentError, TypeError
      nil
    end   

    def filtered_options(value)
      filtered = options.dup
      filtered[:value] = value
      filtered
    end
end

module ActiveModel
  module Validations
    module HelperMethods
      def validates_fractionality_of(*attr_names)
        validates_with FractionalityValidator, _merge_attributes(attr_names)
      end
    end
  end
end
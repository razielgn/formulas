require 'formulas/version'
require 'formulas/eval_sandbox'

module Formulas
  def self.included(base)
    base.extend ClassMethods
  end

  module ClassMethods
    def calculated_field(field)
      define_method("#{field}_calc") do
        code = send(field).to_s
        sandbox_run(field, code)
      end

      define_method("#{field}_error") do
        calculated_fields_errors[field]
      end
    end

    def calculated_fields(*fields)
      fields.each{ |f| calculated_field(f) }
    end

    def calculated_fields_source(receiver, params)
      method = params.fetch(:method, :to_a)
      @@_calculated_fields_source = ->{ receiver.send(method) }
    end

    def get_calculated_fields_source
      @@_calculated_fields_source
    end
  end

  def calculated_fields_errors
    @_calculated_fields_errors ||= {}
    @_calculated_fields_errors
  end

  private

  def sandbox_run(field, code)
    begin
      source = self.class.get_calculated_fields_source.call

      EvalSandbox.new(data_source: source,
                      object_instance: self,
                      code: code).eval!
    rescue SyntaxError, SecurityError => ex
      calculated_fields_errors[field] = ex.message
      nil
    end
  end
end

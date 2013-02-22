require 'formulas/version'
require 'shikashi'

module Formulas
  include Shikashi

  def self.included(base)
    base.extend ClassMethods
  end

  module ClassMethods
    def calculated_field(field)
      define_method("#{field}_calc") do
        code = send(field)
        sandbox_run(field, code)
      end

      define_method("#{field}_error") do
        calculated_fields_errors[field]
      end
    end

    def calculated_fields(*fields)
      fields.each{ |f| calculated_field(f) }
    end
  end

  def calculated_fields_errors
    @_calculated_fields_errors ||= {}
    @_calculated_fields_errors
  end

  private

  def sandbox_run(field, code)
    begin
      Sandbox.new.run(privileges, code)
    rescue Exception => ex
      calculated_fields_errors[field] = ex.message
      nil
    end
  end

  def privileges
    @privileges ||= Privileges.new.tap do |p|
      p.instances_of(Fixnum).allow :+, :-, :*, :/, :**
      p.instances_of(Float).allow  :+, :-, :*, :/, :**
      p.instances_of(Bignum).allow :+, :-, :*, :/, :**
    end
  end
end

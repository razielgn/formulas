require 'shikashi'
require 'active_support/inflector'

module Formulas
  class EvalException < StandardError; end

  class EvalSandbox
    include Shikashi

    attr_reader :data_source, :code, :obj_instance

    def initialize(params = {})
      @data_source  = params.fetch(:data_source)
      @code         = params.fetch(:code)
      @obj_instance = params.fetch(:object_instance)
    end

    def eval!
      sandbox!(code)
    end

    def method_missing(method, *args)
      if param = data_source.find{ |p| p.label == method.to_s }
        evaluate_param(param)
      else
        super
      end
    end

    def respond_to_missing?(method, include_private)
      !!data_source.find{ |p| p.label == method.to_s }
    end

    private

    def sandbox!(code)
      instance_eval(code)
      #Sandbox.new.run(privileges:         privileges,
                      #code:               code,
                      #binding:            binding,
                      #no_base_namespace:  true)
    end

    def evaluate_param(param)
      class_name = param.class_name
      message    = param.message

      relation   = class_name.tableize.singularize

      if of_class?(obj_instance, class_name) && obj_instance.respond_to?(message)
        #if not obj_instance.respond_to? message
          #raise EvalException, "#{obj_instance} doesn't respond to #{message}"
        #end

        result = obj_instance.send(message)
      elsif obj_instance.respond_to?(relation)
        #obj_instance = obj_instance.send(relation)

        #if not obj_instance.respond_to? message
          #raise EvalException, "#{obj_instance} doesn't respond to #{message}"
        #end

        result = obj_instance.send(relation).send(message)
      else
        raise EvalException, "#{obj_instance} doesn't respond to #{relation}"
      end

      #if result.nil?
        #raise EvalException, "#{relation}.#{message} is nil!"
      #end

      sandbox!(result.to_s)
    end

    #def create_context!
      #singleton = class << self; self; end

      #data_source.each do |param|
        #singleton.send(:define_method, param.label) do
        #end
      #end
    #end

    def of_class?(obj, class_name_str)
      obj.class.to_s == class_name_str
    end

    def privileges
      Privileges.new.tap do |p|
        p.instances_of(Fixnum).allow :+, :-, :*, :/, :**
        p.instances_of(Float).allow  :+, :-, :*, :/, :**
        p.instances_of(Bignum).allow :+, :-, :*, :/, :**

        data_source.each do |param|
          p.instances_of(self.class).allow param.label.to_sym
        end
      end
    end
  end

      #calcolatore = Object.new do
        #source.each do |param|
          #define_method(param.label) do
            #class_name = params.class_name
            #message    = param.message

            #relation = class_name.tableize.singularize

            #if instance.class.to_s == class_name
              #if not instance.respond_to? message
                #raise "#{instance} doesn't respond to #{message}"
              #end

              #result = instance.send(message)
            #else
              #if not instance.respond_to? relation
                #raise "#{instance} doesn't respond to #{relation}"
              #end

              #instance = instance.send(relation)
              #if not instance.respond_to? message
                #raise "#{instance} doesn't respond to #{message}"
              #end

              #result = instance.send(message)
            #end

            #if result.nil?
              #raise "#{relation}.#{message} is nil!"
            #end

            #result
          #end
        #end

        #def initialize(privileges, code)

        #end
      #end


      #Sandbox.new.run(privileges, code)
end

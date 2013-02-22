require 'spec_helper'
require 'ostruct'

Source = [
  OpenStruct.new(label: 'aFFA', class_name: 'SimpleAttributes',  message: 'attr1_calc'),
  OpenStruct.new(label: 'aFFB', class_name: 'SimpleAttributes',  message: 'attr2_calc'),
  OpenStruct.new(label: 'iTFP', class_name: 'ComplexAttributes', message: 'attr1_calc')
]

class SimpleAttributes
  include Formulas

  calculated_fields :attr1, :attr2
  calculated_fields_source Source, method: :to_a

  attr_reader :attr1, :attr2

  def initialize(params = {})
    @attr1 = params[:attr1]
    @attr2 = params[:attr2]
  end
end

class ComplexAttributes
  include Formulas

  calculated_fields :attr1, :attr2
  calculated_fields_source Source, method: :to_a

  attr_reader :attr1, :attr2

  def initialize(params = {})
    @attr1 = params[:attr1]
    @attr2 = params[:attr2]
  end

  def simple_attribute
    SimpleAttributes.new(attr1: '2 * 10', attr2: 'aFFA * 25')
  end
end

describe 'Formulas' do
  context 'simple attributes' do
    context 'integers' do
      [['+',  '2 + 2',  4],
       ['-',  '2 - 2',  0],
       ['*',  '2 * 2',  4],
       ['/',  '2 / 2',  1],
       ['**', '2 ** 2', 4]].each do |op, code, res|
         context "#{op} should be allowed" do
          subject{ SimpleAttributes.new(attr1: code) }
          its(:attr1_calc){ should == res }
         end
       end
    end

    context 'floats' do
      [['+',  '2.0 + 2',  4.0],
       ['-',  '2.0 - 2',  0.0],
       ['*',  '2.0 * 2',  4.0],
       ['/',  '2.0 / 2',  1.0],
       ['**', '2.0 ** 2', 4.0]].each do |op, code, res|
         context "#{op} should be allowed" do
          subject{ SimpleAttributes.new(attr1: code) }
          its(:attr1_calc){ should == res }
         end
       end
    end

    context 'unallowed stuff' do
      subject{ SimpleAttributes.new(attr1: '2.times{ puts "asd" }') }

      it 'should store the error' do
        subject.attr1_calc.should be_nil
        subject.attr1_error.should == 'Cannot invoke method times on object of class Integer'
      end
    end

    context 'syntax error' do
      subject{ SimpleAttributes.new(attr1: '(2 + 3') }

      it 'should store the error' do
        subject.attr1_calc.should be_nil
        subject.attr1_error.should == 'SyntaxError'
      end
    end

    context 'nil parameter' do
      subject{ SimpleAttributes.new(attr1: nil) }

      it 'should not store any errors' do
        subject.attr1_calc.should be_nil
        subject.attr1_error.should be_nil
      end
    end
  end

  context 'complex attributes' do
    context 'referencing existing attributes within the object' do
      subject{ ComplexAttributes.new(attr1: 'aFFB * aFFA', attr2: '4 * iTFP') }

      its(:attr1_calc){ should == 10000 }
      its(:attr2_calc){ should == 40000 }
    end
  end
end

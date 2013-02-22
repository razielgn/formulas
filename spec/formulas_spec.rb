require 'spec_helper'

class SimpleAttributes
  include Formulas

  calculated_fields :attr1, :attr2

  attr_reader :attr1, :attr2

  def initialize(params = {})
    @attr1 = params[:attr1]
    @attr2 = params[:attr2]
  end
end

describe 'Formulas' do
  context 'simple attributes' do
    context 'integers' do
      context '+ should be allowed' do
        subject{ SimpleAttributes.new(attr1: '2 + 2') }
        its(:attr1_calc){ should == 4 }
      end

      context '- should be allowed' do
        subject{ SimpleAttributes.new(attr1: '2 - 2') }
        its(:attr1_calc){ should == 0 }
      end

      context '* should be allowed' do
        subject{ SimpleAttributes.new(attr1: '2 * 2') }
        its(:attr1_calc){ should == 4 }
      end

      context '/ should be allowed' do
        subject{ SimpleAttributes.new(attr1: '2 / 2') }
        its(:attr1_calc){ should == 1 }
      end

      context '** should be allowed' do
        subject{ SimpleAttributes.new(attr1: '2 ** 2') }
        its(:attr1_calc){ should == 4 }
      end
    end

    context 'floats' do
      context '+ should be allowed' do
        subject{ SimpleAttributes.new(attr1: '2.0 + 2') }
        its(:attr1_calc){ should == 4.0 }
      end

      context '- should be allowed' do
        subject{ SimpleAttributes.new(attr1: '2.0 - 2') }
        its(:attr1_calc){ should == 0.0 }
      end

      context '* should be allowed' do
        subject{ SimpleAttributes.new(attr1: '2.0 * 2') }
        its(:attr1_calc){ should == 4.0 }
      end

      context '/ should be allowed' do
        subject{ SimpleAttributes.new(attr1: '2.0 / 2') }
        its(:attr1_calc){ should == 1.0 }
      end

      context '** should be allowed' do
        subject{ SimpleAttributes.new(attr1: '2.0 ** 2') }
        its(:attr1_calc){ should == 4.0 }
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
end

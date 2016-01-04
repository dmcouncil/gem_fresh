require 'spec_helper'

describe Gemfresh::Calculator do
  describe "constants" do
    it { expect(Gemfresh::Calculator::POINTS_FOR_MAJOR).to eq(100) }
    it { expect(Gemfresh::Calculator::POINTS_FOR_MINOR).to eq(10) }
    it { expect(Gemfresh::Calculator::POINTS_FOR_PATCH).to eq(1) }

    it { expect(Gemfresh::Calculator::MINIMAL_MULTIPLIER).to eq(0.1) }
    it { expect(Gemfresh::Calculator::LOCAL_MULTIPLIER).to eq(1) }
    it { expect(Gemfresh::Calculator::SYSTEM_MULTIPLIER).to eq(10) }
    it { expect(Gemfresh::Calculator::FRAMEWORK_MULTIPLIER).to eq(100) }
  end

  describe "#new" do
    subject(:calculator) { Gemfresh::Calculator.new }
    it "initializes @freshness_scores" do
      expect(calculator.instance_variable_get('@freshness_scores')).to eq({})
    end
  end
end


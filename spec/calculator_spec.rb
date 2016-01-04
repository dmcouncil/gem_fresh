require 'spec_helper'

describe GemFresh::Calculator do
  describe "constants" do
    it { expect(GemFresh::Calculator::POINTS_FOR_MAJOR).to eq(100) }
    it { expect(GemFresh::Calculator::POINTS_FOR_MINOR).to eq(10) }
    it { expect(GemFresh::Calculator::POINTS_FOR_PATCH).to eq(1) }

    it { expect(GemFresh::Calculator::MINIMAL_MULTIPLIER).to eq(0.1) }
    it { expect(GemFresh::Calculator::LOCAL_MULTIPLIER).to eq(1) }
    it { expect(GemFresh::Calculator::SYSTEM_MULTIPLIER).to eq(10) }
    it { expect(GemFresh::Calculator::FRAMEWORK_MULTIPLIER).to eq(100) }
  end

  describe "#new" do
    subject(:calculator) { GemFresh::Calculator.new }
    it "initializes @freshness_scores" do
      expect(calculator.instance_variable_get('@freshness_scores')).to eq({})
    end
  end
end


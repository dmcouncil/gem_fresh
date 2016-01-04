require 'spec_helper'

describe GemFresh::GemVersion do
  let(:gem_version) { GemFresh::GemVersion.new(version_string) }

  context "when version_string is 7.6.2" do
    let(:version_string) { "7.6.2" }
    it { expect(gem_version.major).to eq(7) }
    it { expect(gem_version.minor).to eq(6) }
    it { expect(gem_version.patch).to eq(2) }
  end

  context "when version_string is 2.1" do
    let(:version_string) { "2.1" }
    it { expect(gem_version.major).to eq(2) }
    it { expect(gem_version.minor).to eq(1) }
    it { expect(gem_version.patch).to eq(0) }
  end

  context "when version_string is 2.1.2.beta" do
    let(:version_string) { "2.1.2.beta" }
    it { expect(gem_version.major).to eq(2) }
    it { expect(gem_version.minor).to eq(1) }
    it { expect(gem_version.patch).to eq(2) }
  end
end

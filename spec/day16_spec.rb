require 'day16'

describe FlawedFrequencyTransmission do
  let(:fft) { described_class.new data.split("").map(&:to_i) }

  describe "#transform" do
    subject { fft.transform(iterations).inspect }

    context "when data is 12345678 and iterations is 4" do
      let(:data) { "12345678" }
      let(:iterations) { 4 }
      it { is_expected.to eq "01029498" }
    end
  end
end

describe Day16 do
  before { allow(File).to receive(:read).with('data/day16.txt').and_return data }

  describe 'part 1' do
    subject { Day16.new.run_one }

    context "when data is 80871224585914546619083218645595 and iterations is 100" do
      let(:data) { "80871224585914546619083218645595" }
      it { is_expected.to eq "24176176" }
    end

    context "when data is 19617804207202209144916044189917 and iterations is 100" do
      let(:data) { "19617804207202209144916044189917" }
      it { is_expected.to eq "73745418" }
    end

    context "when data is 69317163492948606335995924319873 and iterations is 100" do
      let(:data) { "69317163492948606335995924319873" }
      it { is_expected.to eq "52432133" }
    end
  end

  describe 'part 2' do
    subject { Day16.new.run_two }

    context "when data is 03036732577212944063491565474664 and iterations is 100" do
      let(:data) { "03036732577212944063491565474664" }
      it { is_expected.to eq "84462026" }
    end

    context "when data is 02935109699940807407585447034323 and iterations is 100" do
      let(:data) { "02935109699940807407585447034323" }
      it { is_expected.to eq "78725270" }
    end

    context "when data is 03081770884921959731165446850517 and iterations is 100" do
      let(:data) { "03081770884921959731165446850517" }
      it { is_expected.to eq "53553731" }
    end
  end
end

describe FlawedFrequencyTransmission::Phase do
  let(:phase) { described_class.new numbers }
  let(:numbers) { (1..8).to_a }

  describe "#advance!" do
    it "works the first four times" do
      expect(phase.inspect).to eq "12345678"
      expect(phase.transform!.inspect).to eq "48226158"
      expect(phase.transform!.inspect).to eq "34040438"
      expect(phase.transform!.inspect).to eq "03415518"
    end
  end
end


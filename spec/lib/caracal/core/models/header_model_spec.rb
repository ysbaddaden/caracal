require 'spec_helper'

describe Caracal::Core::Models::HeaderModel do
  subject do
    described_class.new do
      show true
    end
  end

  #-------------------------------------------------------------
  # Configuration
  #-------------------------------------------------------------

  describe 'configuration tests' do

    # accessors
    describe 'accessors' do
      it { expect(subject.header_show).to eq true }
    end

  end


  #-------------------------------------------------------------
  # Public Methods
  #-------------------------------------------------------------

  describe 'public method tests' do

    #=============== SETTERS ==============================

    # .show
    describe '.show' do
      before { subject.show(true) }

      it { expect(subject.header_show).to eq true }
    end


    #=============== VALIDATIONS ==========================

    describe '.valid?' do
      describe 'when show is false' do
        before do
          allow(subject).to receive(:header_show).and_return(false)
        end

        it { expect(subject.valid?).to eq false }
      end

      describe 'when show is true' do
        before do
          allow(subject).to receive(:header_show).and_return(true)
        end

        it { expect(subject.valid?).to eq true }
      end
    end

  end


  #-------------------------------------------------------------
  # Private Methods
  #-------------------------------------------------------------

  describe 'private method tests' do

    # .option_keys
    describe '.option_keys' do
      let(:actual)   { subject.send(:option_keys).sort }
      let(:expected) { [:show, :content, :width, :margin_left, :margin_right].sort }

      it { expect(actual).to eq expected }
    end

  end

end

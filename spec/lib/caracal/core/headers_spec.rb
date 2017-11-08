require 'spec_helper'

describe Caracal::Core::Headers do
  subject { Caracal::Document.new }


  #-------------------------------------------------------------
  # Configuration
  #-------------------------------------------------------------

  describe 'configuration tests' do

    # readers
    describe 'header readers' do
      it { expect(subject.header_contents).to eq nil }
      it { expect(subject.header_relationships).to eq [] }
      it { expect(subject.header_show).to eq nil }
    end
  end


  #-------------------------------------------------------------
  # Public Methods
  #-------------------------------------------------------------

  describe 'public methods tests' do

    # .header
    describe '.header' do
      describe 'when nothing given' do
        before { subject.header }

        it { expect(subject.header_contents).to eq nil }
        it { expect(subject.header_show).to eq false }
      end

      describe 'when explicitly turned off' do
        before { subject.header false }

        it { expect(subject.header_contents).to eq nil }
        it { expect(subject.header_show).to eq false }
      end

      describe 'when options given' do
        before { subject.header true, content: "lorem ipsum" }

        it { expect(subject.header_contents.size).to eq 1 }
        it { expect(subject.header_contents.last).to be_a(Caracal::Core::Models::ParagraphModel) }
        it { expect(subject.header_show).to eq true }
      end

      describe 'when block given' do
        before do
          subject.header false do
            show true
            p "lorem ipsum"
            img "/tmp/file.jpg", width: 200, height: 300
          end
        end

        it { expect(subject.header_contents.size).to eq 2 }
        it { expect(subject.header_contents.first).to be_a(Caracal::Core::Models::ParagraphModel) }
        it { expect(subject.header_contents.last).to be_a(Caracal::Core::Models::ImageModel) }
        it { expect(subject.header_show).to eq true }
      end

      describe 'when fancy block given' do
        subject do
          Caracal::Document.new do |docx|
            t = 'This is text'
            docx.header true do
              p t
            end
          end
        end

        it { expect(subject.header_contents.size).to eq 1 }
        it { expect(subject.header_contents.last).to be_a(Caracal::Core::Models::ParagraphModel) }
        it { expect(subject.header_show).to eq true }
      end
    end

  end
end

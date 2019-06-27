require 'spec_helper'
require 'eyes_selenium'
require_relative 'applitools_eyes.rb'

RSpec.describe AcornsQa::ApplitoolsEyes do
  let(:eyes) { instance_double('Applitools::Selenium::Eyes') }
  after(:each) do
    if described_class.instance_variable_defined? :@is_active
      described_class.remove_instance_variable :@is_active
    end
  end

  describe '.configure' do
    context 'when Applitools is not active' do
      it 'does not configure Applitools' do
        allow(described_class).to receive(:active?).and_return(false)
        expect(described_class).to receive(:eyes).and_return(nil)
        described_class.configure(api_key: 'test!', active: false)
        expect(described_class.instance_variable_get(:@is_active)).to eq(false)
      end
    end

    context 'when Applitools is active' do
      it 'successfully configures the applitools client' do
        allow(described_class).to receive(:eyes).and_return(eyes)
        expect(eyes).to receive(:api_key=).with('test!')
        described_class.configure(api_key: 'test!', active: true)
        expect(described_class.instance_variable_get(:@is_active)).to eq(true)
      end
    end
  end

  describe '.active?' do
    context 'when Applitools is not active' do
      before(:each) { described_class.configure(active: false) }
      it 'returns false' do
        expect(described_class.active?).to be false
      end
    end

    context 'when Applitools is active' do
      before(:each) { described_class.configure(active: true) }
      it 'returns true' do
        expect(described_class.active?).to be true
      end
    end
  end

  describe '.open' do
    context 'when Applitools is not active' do
      before(:each) { described_class.configure(active: false) }
      it 'returns nil' do
        expect(described_class.open(test_name: '', driver: '')).to be nil
      end
    end

    context 'when Applitools is active' do
      it 'successfully opens a connection' do
        allow(described_class).to receive(:eyes).and_return(eyes)

        expect(eyes).to receive(:open).with(
          app_name: 'rspec',
          test_name: 'test',
          driver: :test
        )

        described_class.open(
          app_name: 'rspec',
          test_name: 'test',
          driver: :test
        )
      end
    end
  end

  describe '.close' do
    context 'when Applitools is not active' do
      before(:each) { described_class.configure(active: false) }
      it 'returns nil' do
        expect(described_class).to receive(:eyes)
        expect(described_class.close).to be nil
      end
    end

    context 'when Applitools is active' do
      it 'successfully closes a connection' do
        allow(described_class).to receive(:eyes).and_return(eyes)
        expect(eyes).to receive(:close)
        described_class.close
      end
    end
  end

  describe '.abort_if_not_closed' do
    context 'when Applitools is not active' do
      it 'returns nil' do
        described_class.configure(active: false)
        expect(described_class.abort_if_not_closed).to be nil
      end
    end

    context 'when Applitools is active' do
      it 'successfully aborts a connection' do
        allow(described_class).to receive(:eyes).and_return(eyes)

        expect(eyes).to receive(:abort_if_not_closed)
        described_class.abort_if_not_closed
      end
    end
  end

  describe '.check_window' do
    context 'when Applitools is not active' do
      it 'returns nil if eyes object is not created' do
        described_class.configure(active: false)
        expect(described_class.check_window('test')).to be nil
      end
    end

    context 'when Applitools is active' do
      it 'successfully checks a window' do
        allow(described_class).to receive(:eyes).and_return(eyes)
        expect(eyes).to receive(:check_window).with('Test123')
        described_class.check_window 'Test123'
      end
    end
  end

  describe '.eyes' do
    context 'when Applitools is active' do
      before(:each) { described_class.configure(active: true) }
      it 'returns an Applitools Eyes object' do
        expect(described_class.eyes).to be_a Applitools::Selenium::Eyes
      end
    end

    context 'when Applitools is not active' do
      before(:each) { described_class.configure(active: false) }
      it 'returns nil' do
        expect(described_class.eyes).to be_nil
      end
    end
  end
end

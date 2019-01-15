require 'rails_helper'

RSpec.describe ClockEvent, type: :model do
  context 'without time_in' do
    let(:clock_event) { build :clock_event, time_in: nil }

    it 'is invalid due to no start time' do
      expect(clock_event.valid?).to eq(false)
    end
  end

  context 'without name' do
    let(:clock_event) { build :clock_event, name: nil }

    it 'is invalid due to no name' do
      expect(clock_event.valid?).to eq(false)
    end
  end

  context 'without time_out' do
    let(:clock_event) { create :clock_event, time_out: nil }

    it 'will be valid, and next operation will be punch out' do
      expect(ClockEvent.punch_out?(clock_event.name)).to eq(true)
    end
  end

  context 'complete' do
    let(:clock_event) { create :clock_event }

    it 'will be valid, and next operation will be punch in' do
      expect(ClockEvent.punch_out?(clock_event.name)).to eq(false)
    end
  end

  context 'user_events' do
    let(:clock_event) { create :clock_event }

    it 'will return clock_event' do
      expect(ClockEvent.user_events(clock_event.name).first).to eq(clock_event)
    end
  end
end

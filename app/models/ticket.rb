class Ticket < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :event

  before_save :set_total_price

  def self.startsbefore_endsafter(arrival, departure)
    where('starts_at < ? AND ends_at > ?', arrival, departure)
  end

  def self.starts_during(arrival, departure)
    where('starts_at > ? AND starts_at < ?', arrival, departure)
  end

  def self.ends_during(arrival, departure)
    where('ends_at > ? AND ends_at < ?', arrival, departure)
  end

  def self.during(arrival, departure)
      arrival = arrival.change(hour: 14, min: 00, sec: 00)
      departure = departure.change(hour: 11, min: 00, sec: 00)

      startsbefore_endsafter(arrival, departure)
      .or(starts_during(arrival, departure))
      .or(ends_during(arrival, departure))
  end

  def self.sametime_events(arrival, departure)
    during(arrival, departure).pluck(:event_id)
  end

  def self.non_sametime_events(arrival, departure)

  end

  def set_total_price
    self.price = event.price * amount
  end
end

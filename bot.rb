require 'twitter'
require 'holiday_japan'

LAST_DATE_OF_2013 = DateTime.new(2013, 12, 27)

class Date
  def holiday?
    self.saturday? || self.sunday? || self.national_holiday?
  end
end

def last_businnes_dates_to(last_date)
  last_date += 1
  (Date.today...last_date).reject { |date| date.holiday? }.size
end

def last_businnes_dates
  last_businnes_dates_to(LAST_DATE_OF_2013)
end

def tweet(text)
  client = Twitter::REST::Client.new do |config|
    config.consumer_key        = ENV['CONSUMER_KEY']
    config.consumer_secret     = ENV['CONSUMER_SECRET']
    config.access_token        = ENV['ACCESS_TOKEN']
    config.access_token_secret = ENV['ACCESS_TOKEN_SECRET']
  end

  client.update(text)
end

def text
  <<-TEXT
今年も今日を入れて、あとのこり#{last_businnes_dates}営業日! #営業日bot
  TEXT
end


def main
  tweet(text.strip) unless Date.today.holiday?
end

main

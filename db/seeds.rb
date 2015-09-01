require 'open-uri'

doc = Nokogiri::HTML(open("http://en365.ru/top500.htm"))

cards = doc.css('td#middle>table tr:nth-child(n+2)').map do |el|
  el.css('td').map(&:text)
end
cards = cards.flatten.in_groups_of(3)

Card.delete_all

ActiveRecord::Base.transaction do
  cards.each do |card|
    orig_text = card[1].gsub(/\[.*\]/,"").strip
    tran_text = card[2].strip
    Card.create(original_text: orig_text, translated_text: tran_text)
  end
end
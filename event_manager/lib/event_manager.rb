require 'csv'
require 'google/apis/civicinfo_v2'
require 'erb'

def clean_zipcode(zipcode)
  zipcode.to_s.rjust(5, '0')[0..4]
end

def legislators_by_zipcode(zip)
  civic_info = Google::Apis::CivicinfoV2::CivicInfoService.new
  civic_info.key = 'AIzaSyClRzDqDh5MsXwnCWi0kOiiBivP6JsSyBw'

  begin
    civic_info.representative_info_by_address(
      address: zip,
      levels: 'country',
      roles: %w[legislatorUpperBody legislatorLowerBody]
    ).officials
  rescue StandardError
    'You can find your representatives by visiting www.commoncause.org/take-action/find-elected-officials'
  end
end

def save_thank_you_letter(id, form_letter)
  Dir.mkdir('output') unless Dir.exist?('output')

  filename = "output/thanks_#{id}.html"

  File.open(filename, 'w') do |file|
    file.puts form_letter
  end
end

def process_phone(phone)
  phone = phone.scan(/\d+/).join('')
  if phone.length < 10
    '0' * 10
  elsif phone.length > 10
    phone[0] == '1' ? phone[1..phone.length] : '0' * 10
  else
    phone
  end
end

def most_occurances(array)
  groups = array.group_by { |value| value }
  groups.max_by { |_, values| values.length }[0]
end

puts 'EventManager initialized.'

weekdays = %w[Sunday Monday Tuesday Wednesday Thursday Friday Saturday]

contents = CSV.open(
  'event_attendees.csv',
  headers: true,
  header_converters: :symbol
)

template_letter = File.read('form_letter.erb')
erb_template = ERB.new template_letter

times = []
days = []
contents.each do |row|
  id = row[0]
  name = row[:first_name]
  zipcode = clean_zipcode(row[:zipcode])
  legislators = legislators_by_zipcode(zipcode)

  phone = process_phone(row[:homephone])

  date = Time.strptime(row[:regdate], '%m/%d/%y %H:%M')
  time = date.strftime('%H').to_i
  day = date.wday

  times += [time]
  days += [day]

  form_letter = erb_template.result(binding)

  save_thank_you_letter(id, form_letter)
end

puts "Peak registration hour is: #{most_occurances(times)}"
puts "Peak registration day is: #{weekdays[most_occurances(days)]}"

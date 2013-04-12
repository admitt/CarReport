#Kategooria;Mark;Mudel;Keretyyp;Väljalaske aasta;Mootori tüüp;Mootori võimsus;Maakond;Arv

Entry = Struct.new(:category, :brand, :model, :body_type, :make, :motor_type, :power_kw, :county, :count) do
  def to_hash
    members.inject(Hash.new) do |output, member|
      output.store(member, self[member])
      output
    end
  end
end

private
ALL_ENTRIES = []

File.open('car_report.csv', 'r').each_line do |line|
  ALL_ENTRIES << Entry.new(*line.gsub(/\n/, '').split(';'))
end

def query(params)
  ALL_ENTRIES.select { |entry| params.inject(true) { |valid, param| valid and (param[1].casecmp(entry[param[0]]) == 0)} }
end

def car_count(search_criteria)
  query(search_criteria).inject(0) { |sum, entry| sum + entry.count.to_i }
end

def valid?(search_criteria)
  (search_criteria.keys - Entry.members).empty?
end
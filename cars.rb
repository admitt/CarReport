#Kategooria;Mark;Mudel;Keretyyp;Väljalaske aasta;Mootori tüüp;Mootori võimsus;Maakond;Arv

Entry = Struct.new(:category, :brand, :model, :body_type, :make, :motor_type, :power_kw, :county, :count) do
  def to_hash
    members.inject(Hash.new) do |output, member|
      output.store(member, self[member])
      output
    end
  end
end

class CsvDataSource
  def initialize(io)
    @all_entries = []
    io.each_line do |line|
      @all_entries << Entry.new(*line.gsub(/\n/, '').split(';'))
    end
  end

  def filter(&predicate)
    @all_entries.select &predicate
  end

  def group_by(property)
    @all_entries.group_by { |entry| entry[property]}
  end
end

DATA_SOURCE = CsvDataSource.new(File.open('car_report.csv', 'r'))
def query(params)
  DATA_SOURCE.filter { |entry| params.inject(true) { |valid, param| valid and (param[1].casecmp(entry[param[0]]) == 0) } }
end

def counts_by(property)
  DATA_SOURCE.group_by(property).map {|key, entries| {key => sum_counts(entries)}}
end

def car_count(search_criteria)
  sum_counts(query(search_criteria))
end

def valid?(search_criteria)
  (search_criteria.keys - Entry.members).empty?
end

def sum_counts(entries)
  entries.inject(0) { |sum, entry| sum + entry.count.to_i }
end

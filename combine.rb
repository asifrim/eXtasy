#!/usr/bin/env ruby
require File.expand_path('../config.rb', __FILE__)

if ARGV == []
	puts "=================================================================================================="
	puts "Usage: combine.rb <PRIO_1> <PRIO_2>...<PRIO_N>"
	puts "This command combines multiple prioritizations into a global prioritization using order statistics"
	puts "Keep in mind that it expects prioritizations of the same vcf file!"
	puts "Tip: You can use wildcards such as * to specify a list of filenames based on the same vcf file"
	puts "=================================================================================================="
end

puts "#{Time.now}: Combining: #{ARGV.join(", ")}"



combinefilename = File.basename(ARGV[0]).split("_-_")[0]+".combined"

`cut -f 1-4,18 #{ARGV[0]} > #{combinefilename}`

ARGV.each do |file|
	s = File.basename(file).split("_-_")[1]
	`cat #{file} | awk '{if($34 == "NA"){print $35}else{print $34}}' | sed 's/extasy_complete/#{Regexp.escape(s)}/' |  paste #{combinefilename} - > #{combinefilename}_tmp`
	`mv #{combinefilename}_tmp #{combinefilename}`
end

puts "#{Time.now}: Applying order statistics for combining phenotypes..."

`#{RCOMMAND} --no-save --no-restore --args #{combinefilename} < order_statistics.r`

file = File.open("#{combinefilename}.order_statistics_output")
combinefile = File.open("#{combinefilename}")
variantfile = File.open(ARGV[0])
combined_scores = {}
outputfile = File.open(File.basename(ARGV[0]).split("_-_")[0]+".combined.extasy",'w')

file.gets
puts "#{Time.now}: Outputting combined prioritization..."
while line = file.gets
	data = line.chomp.split("\t")
	combined_scores[data[0]] = data[1]
end

variantinfo = {}
varheader = variantfile.gets.chomp.split("\t")[0..32]
while line = variantfile.gets
	data = line.chomp.split("\t")
	variantinfo[data[17]] = data[0..32]
end

combinefileheader = combinefile.gets.chomp.split("\t")
combinefileheader = combinefileheader[5..combinefileheader.size]
outputfile.puts("#{varheader.join("\t")}\t#{combinefileheader.join("\t")}\textasy_combined")
outputarray = []
while line = combinefile.gets
	data = line.chomp.split("\t")
	varinf = variantinfo[data[4]]
	combscore = combined_scores[data[4]]
	res = []
	res.concat(varinf)
	res.concat(data[5..data.size])
	res.concat([combscore])
	outputarray << res
end
outputarray.sort_by{|x| x[-1].to_f}.each{|x| outputfile.puts(x.join("\t")+"\n")}

File.delete(combinefilename)
File.delete("#{combinefilename}.order_statistics_output")


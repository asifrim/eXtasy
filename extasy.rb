#!/usr/bin/env ruby
require  File.expand_path('../parse_arguments.rb', __FILE__)
require  File.expand_path('../vcf.rb', __FILE__)
require  File.expand_path('../tabix.rb', __FILE__)
require  File.expand_path('../intersectbed.rb', __FILE__)
require  File.expand_path('../config.rb', __FILE__)
require  File.expand_path('../endeavour.rb', __FILE__)


class Extasy

	def self.run_extasy(extasy_input_file)
		puts "#{Time.now}: Running eXtasy..."
		`#{RCOMMAND} --no-save --no-restore --args #{extasy_input_file} #{COMPLETEMODEL} #{INCOMPLETEMODEL} < #{File.expand_path('../run_extasy.r', __FILE__)} > /dev/null`
		puts "#{Time.now}: eXtasy prioritization completed!"
		return "#{extasy_input_file}.extasy_output"
	end

end


options = ParseArguments.parse(ARGV)

unless options.resume == true
sorted_file = Intersectbed.sort_file(options.vcf_file)
matches_file = Intersectbed.intersect_lines(sorted_file)
annotated_file = Tabix.scan_matches_file(matches_file)
else
	puts "#{Time.now}: Resuming from intermediate files..."
	annotated_file = options.vcf_file+".sorted.matches.annotated"
	if !File.file?(annotated_file)
		puts "#{Time.now}: Intermediate files could not be found! Run eXtasy without the -r function to generate these files."
		exit
	end
end

newfilenames = []
extasy_input_files = []
options.geneprio_files.split(",").each do |geneprio_file|
	puts "#{Time.now}: Prioritizing against #{geneprio_file}"
	extasy_input_file = Endeavour.append_gene_prioritizations(annotated_file, geneprio_file)
	extasy_input_files << extasy_input_file
	extasy_output_file = Extasy.run_extasy(extasy_input_file)
	prioname = File.basename(geneprio_file).split(".")[0]
	if options.prefix == nil
		newfilename = "#{options.vcf_file.gsub(/\.vcf$/,"")}_-_#{prioname}.extasy"
	else
		newfilename = "#{File.dirname(options.vcf_file)}/#{options.prefix}_-_#{prioname}.extasy"
	end
	newfilenames << newfilename
    File.rename("#{options.vcf_file}.sorted.matches.annotated.extasy_input.extasy_output",newfilename)
end

if newfilenames.size > 1 && options.combine == true
	puts `#{File.expand_path('../combine.rb', __FILE__)} #{newfilenames.join(" ")}`
	newfilenames << newfilenames[0].split("_-_")[0]+".combined.extasy"
end

unless options.keep == true || options.resume == true
File.delete(sorted_file)
File.delete(matches_file)
File.delete(annotated_file)
extasy_input_files.each{|x| File.delete(x)}
puts "#{Time.now}: Intermediate files deleted..."
end



if options.zip == true
	puts "#{Time.now}: Compressing the outputfile"
	if options.prefix == nil
		`tar -pczf #{options.vcf_file.gsub(/\.vcf$/,"")}.extasy.tar.gz  #{newfilenames.join(" ")} 2>&1`
	else
		`tar -pczf #{File.dirname(options.vcf_file)}/#{options.prefix}.extasy.tar.gz -C #{File.dirname(options.vcf_file)} #{newfilenames.map{|x| File.basename(x)}.join(" ")} 2>&1`
	end
end

puts "#{Time.now}: DONE!"



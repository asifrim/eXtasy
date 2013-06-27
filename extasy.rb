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

sorted_file = Intersectbed.sort_file(options.vcf_file)
matches_file = Intersectbed.intersect_lines(sorted_file)
annotated_file = Tabix.scan_matches_file(matches_file)
extasy_input_file = Endeavour.append_gene_prioritizations(annotated_file, options.geneprio_file)
extasy_output_file = Extasy.run_extasy(extasy_input_file)

prioname = File.basename(options.geneprio_file).split(".")[0]
newfilename = "#{options.vcf_file.gsub(/\.vcf$/,"")}_-_#{prioname}.extasy"
File.rename("#{options.vcf_file}.sorted.matches.annotated.extasy_input.extasy_output",newfilename)
File.delete(sorted_file)
File.delete(matches_file)
File.delete(annotated_file)
File.delete(extasy_input_file)
puts "#{Time.now}: Intermediate files deleted..."

if options.zip == true
	puts "#{Time.now}: Compressing the outputfile"
	`gzip #{newfilename}`
end
puts "#{Time.now}: DONE!"



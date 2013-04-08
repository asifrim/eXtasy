#!/usr/bin/env ruby
require './parse_arguments.rb'
require './vcf.rb'
require './tabix.rb'
require 'zlib'
require './intersectbed.rb'
require './config.rb'
require './statistics.rb'
require './endeavour.rb'


class Extasy

	def self.run_extasy(extasy_input_file)
		puts "#{Time.now}: Running eXtasy..."
		`#{RCOMMAND} --no-save --no-restore --args #{extasy_input_file} #{COMPLETEMODEL} #{INCOMPLETEMODEL} < run_extasy.r > /dev/null`
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


#Tabix.index_vcf_file(options.vcf_file)
#Tabix.find_coverage_and_varfreq(options.vcf_file,extasy_output_file)




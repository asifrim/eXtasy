require 'optparse'
require 'ostruct'
require 'pp'

class ParseArguments
	def self.parse(args)
		options = OpenStruct.new

		opts = OptionParser.new do |opts|
			opts.banner = "Usage: extasy.rb -i <VCF_FILE> -g <GENEPRIO_FILE>"
			
			opts.on("-i", "--vcf <FILE>", "Input VCF file") do |v|
				if !File.file?(v)
					puts "Error: Input VCF file could not be found!: #{v}"
					puts opts 
					exit
				end
				options.vcf_file = v
			end

			opts.on("-g", "--geneprio <FILE>", "Input gene prioritization file") do |v|
				if !File.file?(v)
					puts "Error: Input gene prioritization file could not be found!: #{v}"
					puts opts 
					exit
				end
				options.geneprio_file = v
			end

			opts.on_tail("-z", "--zip", "Compress the output file") do 
				options.zip = true
			end

			opts.on_tail("-h", "--help", "Show this message") do 
				puts opts
				exit
			end
		end

		opts.parse!(args)
		if options.vcf_file.nil? || options.geneprio_file.nil?
			puts "Error: You must specify --vcf and --geneprio"
			puts opts
			exit
		end

		return options
	end

end

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

			opts.on("-g", "--geneprio <FILE>", "Input gene prioritization files (comma-separated)") do |v|
				v.split(",").each do |x|
					if !File.file?(x)
						puts "Error: Input gene prioritization file could not be found!: #{x}"
						puts opts 
						exit
					end
				end
				options.geneprio_files = v
			end

			opts.on("-p", "--prefix <PREFIX>", "Rename the output files to have the given prefix.") do |v|
				options.prefix = v
			end

			opts.on_tail("-z", "--zip", "Compress the output file") do 
				options.zip = true
			end

			opts.on_tail("-k", "--keep", "Keep intermediate files (speeds up computations on follow-up prioritizations on the same vcf file) ") do 
				options.keep = true
			end

			opts.on_tail("-r", "--resume", "If intermediate files are available (by using the -k option), skip the preprocessing steps, this option also automatically keeps intermediate files as if -k was used.") do 
				options.resume = true
			end

			opts.on_tail("-c", "--combine", "If several phenotypes were given for the -g option, combine these individual prioritizations into a global prioritization (this option has no effect if only one phenotype is given).") do 
				options.combine = true
			end

			


			opts.on_tail("-h", "--help", "Show this message") do 
				puts opts
				exit
			end
		end

		opts.parse!(args)
		if options.vcf_file.nil? || options.geneprio_files.nil?
			puts "Error: You must specify --vcf and --geneprio"
			puts opts
			exit
		end

		return options
	end

end

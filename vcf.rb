class Vcf

	def self.skip_header(file)
		count = 0
		while file.gets[0] == "#"
			count += 1
		end
		puts "Parsing VCF: skipped #{count} header lines..."
	end

	def self.parse_line(line)
		result = {}
		data = line.split("\t")
		result[:chromosome] = data[0]
		result[:position] = data[1]
		result[:refbase] = data[3]
		result[:altbase] = data[4]
		#p result
		return result
	end

end
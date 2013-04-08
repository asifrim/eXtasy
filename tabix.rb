class Tabix

	def self.scan_matches_file(matches_file)
		mfile = File.open(matches_file)
		count = 0 
		puts "#{Time.now}: Fetching features for variants..."
		annotation_file = File.open("#{matches_file}.annotated", 'w')
		while line = mfile.gets
			h = Vcf.parse_line(line)
			r = self.find_variant(h)
			if r != nil
				annotation_file.puts(r.join("\t")+"\n")
				count += 1
			end
		end
		annotation_file.close
		puts "#{Time.now}: #{count} missense variants annotated..."
		return "#{matches_file}.annotated"
	end

	def self.find_variant(var = {})
		s = `#{TABIX} #{VARIANTSFILE} #{var[:chromosome]}:#{var[:position]}-#{var[:position]}`
		result = nil
		if s != ""
			data = s.split("\n").map{|x| x.split("\t")}.uniq
			result = data.select{|x| x[2] == var[:altbase]}.first
		end
		return result
	end

	def self.index_vcf_file(vcf_file)
		puts "#{Time.now}: Indexing VCF File..."
		`#{BGZIP} #{vcf_file},sorted && #{TABIX} -p vcf -f #{vcf_file},sorted.gz`
		puts "#{Time.now}: VCF File indexed..."
	end

	def self.find_coverage_and_varfreq(vcf_file,extasy_output_file)
		puts "#{Time.now}: Appending coverage/zygosity/qual..."
		ef = File.open(extasy_output_file)
		while line = ef.gets
			data = line.chomp.split("\t")
			chr = data[0]
			position = data[3]
			s =`#{TABIX} -f #{vcf_file}.sorted.gz #{chr}:#{position}-#{position}`
			p s
		end
	end

end
class	Intersectbed

	def self.sort_file(vcf_file)
		puts "#{Time.now}: Sorting input VCF..."
		`cat #{vcf_file} | grep -v "##" | sed 's/chr//' | sort -k1,1 -k2,2n >  #{vcf_file}.sorted `
		puts "#{Time.now}: Input VCF sorted..."
		return vcf_file+".sorted"
	end

	def self.intersect_lines(sorted_vcf_file)
		puts "#{Time.now}: Finding missense mutations..."
		`#{INTERSECTBED} -wo -a #{sorted_vcf_file} -b #{POSITIONSFILE} -sorted > #{sorted_vcf_file}.matches`
		return sorted_vcf_file+".matches"
	end
end
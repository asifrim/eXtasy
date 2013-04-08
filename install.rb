#!/usr/bin/env ruby
require './config.rb'

puts "#{Time.now}: Installing eXtasy:"

puts "#{Time.now}: Checking requirements..."
if File.exists?(RCOMMAND)
	puts "#{Time.now}: R environment...OK"
else
	puts "ERROR: R environment not found"
	exit
end
puts "#{Time.now}: Check if randomForest is installed, if an error is given here you have to install this by executing \'install.packages(\"randomForest\")\' in R"
`#{RCOMMAND} --no-save --no-restore < check_r_package.r`
if File.exists?(TABIX)
	puts "#{Time.now}: Tabix...OK"
else
	puts "ERROR: Tabix not found"
	exit
end
if File.exists?(BGZIP)
	puts "#{Time.now}: Bgzip...OK"
else
	puts "ERROR: Bgzip not found"
	exit
end
if File.exists?(BEDTOOLS+"/intersectBed")
	puts "#{Time.now}: Bedtools...OK"
else
	puts "ERROR: Bedtools not found"
	exit
end

puts "#{Time.now}: Downloading input files..."

basedir = Dir.pwd
puts "#{Time.now}: Base directory for eXtasy is #{basedir}"
Dir.chdir(basedir+"/input/")

puts "#{Time.now}: Fetching variant annotation file..."
`wget http://homes.esat.kuleuven.be/~bioiuser/eXtasy/variant_annotation_file.extasy.gz`
`wget http://homes.esat.kuleuven.be/~bioiuser/eXtasy/variant_annotation_file.extasy.gz.tbi`

puts "#{Time.now}: Fetching positions file..."
`wget http://homes.esat.kuleuven.be/~bioiuser/eXtasy/positions.bed.gz`
`gzip -d positions.bed.gz`

puts "#{Time.now}: Fetching genes file..."
`wget http://homes.esat.kuleuven.be/~bioiuser/eXtasy/genes.extasy.gz`
`gzip -d genes.extasy.gz`

Dir.chdir(basedir+"/model/")

puts "#{Time.now}: Fetching Random Forest models..."
`wget http://homes.esat.kuleuven.be/~bioiuser/eXtasy/balanced_complete.model.gz`
`gzip -d balanced_complete.model.gz`

`wget http://homes.esat.kuleuven.be/~bioiuser/eXtasy/balanced_incomplete.model.gz`
`gzip -d balanced_incomplete.model.gz`

Dir.chdir(basedir+"/geneprios/")
puts "#{Time.now}: Fetching gene prioritization files..."
`wget http://homes.esat.kuleuven.be/~bioiuser/eXtasy/geneprios.tar.gz`
puts "#{Time.now}: Unpacking gene prioritization files... (this might take little while)"
`tar -vxzf geneprios.tar.gz`

puts "#{Time.now}: INSTALLATION COMPLETE!"




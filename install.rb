#!/usr/bin/env ruby
#require File.expand_path('../config.rb', __FILE__)

puts "#{Time.now}: Installing eXtasy:"

puts "#{Time.now}: Checking requirements..."
if `which R 2>/dev/null` != ""
	RCOMMAND = `which R`
	puts "#{Time.now}: R environment...OK"
else
	puts "ERROR: R environment not found"
	exit
end
puts "#{Time.now}: Check if randomForest and RobustRankAggreg R libraries are installed, if an error is given here you have to install this by executing \'install.packages(\"randomForest\")\' in R"
`#{RCOMMAND.chomp} --no-save --no-restore < check_r_package.r`
if `which tabix 2>/dev/null` != ""
	TABIX = `which tabix`
	puts "#{Time.now}: Tabix...OK"
else
	puts "ERROR: Tabix not found"
	exit
end
if `which bgzip 2>/dev/null`
	BGZIP = `which bgzip`
	puts "#{Time.now}: Bgzip...OK"
else
	puts "ERROR: Bgzip not found"
	exit
end
if `which intersectBed 2>/dev/null`
	INTERSECTBED = `which intersectBed`
	puts "#{Time.now}: Bedtools intersectBed...OK"
else
	puts "ERROR: Bedtools intersectBed not found"
	exit
end

file = File.open(File.expand_path('../config.rb', __FILE__),'w')
file.puts <<-eos
############################################################################################
#
# CONFIGURATION FILE
#
############################################################################################



#PREREQUISITES
##############

#Path the R statistical environment. MAKE SURE TO INSTALL the "randomForest" and "RobustRankAggreg" package!!!
RCOMMAND = "#{RCOMMAND.chomp}"
# Path to Tabix
TABIX="#{TABIX.chomp}"
# Path to Bgzip (bundled with Tabix)
BGZIP="#{BGZIP.chomp}"
# Path to Bedtools intersectBed
INTERSECTBED = "#{INTERSECTBED.chomp}"


#EXTASY FILES (leave as is if you're running a default installation)
####################################################################

# Location of the bed file containing all missense positions in variant annotation file
POSITIONSFILE = File.expand_path('../input/positions.bed',__FILE__)
# Location of variant_annotation_file.extasy.gz
VARIANTSFILE = File.expand_path('../input/variant_annotation_file.extasy.gz', __FILE__)
# Location of genes.extasy
GENESFILE = File.expand_path('../input/genes.extasy',__FILE__)

#Locations of random forest models
COMPLETEMODEL = File.expand_path('../model/balanced_complete.model', __FILE__)
INCOMPLETEMODEL = File.expand_path('../model/balanced_incomplete.model', __FILE__)
eos
file.close

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




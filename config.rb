############################################################################################
#
# CONFIGURATION FILE
#
############################################################################################



#PREREQUISITES
##############

#Path the R statistical environment. MAKE SURE TO INSTALL the "randomForest" package!!!
RCOMMAND = "/usr/bin/R"
# Path to Tabix
TABIX="/freeware/bioi/tabix/current/tabix"
# Path to Bgzip (bundled with Tabix)
BGZIP="/freeware/bioi/tabix/current/bgzip"
# Path to Bedtools
BEDTOOLS = "/users/sista/asifrim/bin/"


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

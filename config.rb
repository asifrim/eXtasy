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
POSITIONSFILE = "./input/positions.bed"
# Location of variant_annotation_file.extasy.gz
VARIANTSFILE = "./input/variant_annotation_file.extasy.gz"
# Location of genes.extasy
GENESFILE = "./input/genes.extasy"

#Locations of random forest models
COMPLETEMODEL = "./model/balanced_complete.model"
INCOMPLETEMODEL = "./model/balanced_incomplete.model"

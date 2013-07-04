class Endeavour
	def self.append_gene_prioritizations(annotated_file,geneprio_file)
		puts "#{Time.now}: Appending gene prioritization data..."
		genehash= self.create_gene_translation_table(GENESFILE)
		gp_hash = self.gp_to_hash(geneprio_file)
		afile = File.open(annotated_file)
		outputfile = File.open(annotated_file+".extasy_input",'w')
		outputfile.puts("chromosome\trefbase\taltbase\tposition\tgenename\tcarol_score\thaploinsufficiency\tlrt_score\tmutationtaster_score\tphastconsplacentalmammals\tphastconsprimates\tphastconsvertebrate\tphylopplacentalmammals\tphylopprimates\tphylopvertebrate\tpolyphen_score\tsift_score\tvariant_id\tblast\texpression_sueta1\tgene_ontology\tinteraction_biogrid\tinteraction_hprd\tinteraction_innetdb\tinteraction_string\tinterpro\tkegg\tnb\tp_val\tprecalculated_ouzounis\tq_int\tswissprot\ttext\n")
		while line = afile.gets
			data = line.chomp.split("\t")
			gene = genehash[data[4]]
			gp = gp_hash[gene]
			if gp == nil
				next
			else
			   outputfile.puts(line.chomp+"\t#{gp[:blast]}\t#{gp[:expression_sueta1]}\t#{gp[:gene_ontology]}\t#{gp[:interaction_biogrid]}\t#{gp[:interaction_hprd]}\t#{gp[:interaction_innetdb]}\t#{gp[:interaction_string]}\t#{gp[:interpro]}\t#{gp[:kegg]}\t#{gp[:nb]}\t#{gp[:p_val]}\t#{gp[:precalculated_ouzounis]}\t#{gp[:q_int]}\t#{gp[:swissprot]}\t#{gp[:text]}\n")	
			end


		end
		puts "#{Time.now}: Data ready for eXtasy..."
		outputfile.close
		return annotated_file+".extasy_input"

	end

	def self.create_gene_translation_table(genes_file)
		gf = File.open(genes_file)
		genehash = {}
		while line = gf.gets
			data = line.chomp.split("\t")
			genehash[data[0]] = data[1]
		end
		return genehash
	end

	def self.gp_to_hash(geneprio_file)
		f = File.open(geneprio_file,'r')
		genes = {}
		while line = f.gets
			data = line.split("\t")
			value = {}
			data.map!{|x|
				if x == "INFINITY"
					999999
				else
					x
				end
			}  
			value[:nb] = data[0].to_i
			value[:q_int] = data[2].to_f
			value[:p_val] = data[3].to_f
			value[:rank_ratio] = data[4].to_f
			value[:gene_ontology] = data[5].to_f
			value[:gene_ontology_rank_ratio] = data[6].to_f
			value[:interpro] = data[9].to_f
			value[:interpro_rank_ratio] = data[10].to_f
			value[:kegg] = data[11].to_f
			value[:kegg_rank_ratio] = data[12].to_f
			value[:swissprot] = data[7].to_f
			value[:swissprot_rank_ratio] = data[8].to_f
			value[:interaction_string] = data[12].to_f
			value[:interaction_innetdb] = data[16].to_f
			value[:interaction_biogrid] = data[14].to_f
			value[:interaction_hprd] = data[18].to_f
			value[:expression_sueta1] = data[20].to_f
			value[:precalculated_ouzounis] = data[22].to_f
			value[:blast] = data[24].to_f
			value[:text] = data[26].to_f
			value[:interaction_string_rank_ratio] = data[13].to_f
			value[:interaction_innetdb_rank_ratio] = data[17].to_f
			value[:interaction_biogrid_rank_ratio] = data[15].to_f
			value[:interaction_hprd_rank_ratio] = data[19].to_f
			value[:expression_sueta1_rank_ratio] = data[21].to_f
			value[:precalculated_ouzounis_rank_ratio] = data[23].to_f
			value[:blast_rank_ratio] = data[25].to_f
			value[:text_rank_ratio] = data[27].to_f
			genes[data[1]] = value
		end
		return genes
	end
end
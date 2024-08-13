# source: https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/016/699/485/GCF_016699485.2_bGalGal1.mat.broiler.GRCg7b/GCF_016699485.2_bGalGal1.mat.broiler.GRCg7b_assembly_report.txt

# if (!file.exists("data-raw/grcg7b.txt")) {
#   download.file("https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/016/699/485/GCF_016699485.2_bGalGal1.mat.broiler.GRCg7b/GCF_016699485.2_bGalGal1.mat.broiler.GRCg7b_assembly_report.txt", "data-raw/grcg7b.txt")
# }

# grcg7b = readr::read_delim("data-raw/grcg7b.txt", comment = "#", delim = "\t")

grcg7b = readr::read_tsv("data-raw/GRCg7b_sequence_report.tsv") |>
  dplyr::rename(CHROM = `RefSeq seq accession`, chr = `Chromosome name`) |>
  dplyr::select(CHROM, chr)

usethis::use_data(grcg7b, overwrite = TRUE)
